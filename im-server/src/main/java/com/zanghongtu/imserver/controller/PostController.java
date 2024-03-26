package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.page.PageRequest;
import com.zanghongtu.imserver.controller.dto.page.PageResponse;
import com.zanghongtu.imserver.controller.dto.post.PostDTO;
import com.zanghongtu.imserver.controller.dto.post.PostReplyDTO;
import com.zanghongtu.imserver.controller.dto.post.PostSearchType;
import com.zanghongtu.imserver.controller.dto.user.UserInfoDTO;
import com.zanghongtu.imserver.exception.BusinessException;
import com.zanghongtu.imserver.model.*;
import com.zanghongtu.imserver.service.*;
import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 朋友圈
 */
@Slf4j
@RestController
@RequestMapping("posts")
public class PostController extends BaseController {
    private final IPostService postService;

    private final IPostReplyService postReplyService;

    private final IPostLikeService postLikeService;

    private final IUserInfoService userInfoService;

    private final IImageService imageService;

    @Autowired
    public PostController(IPostService postService,
                          IPostReplyService postReplyService,
                          IPostLikeService postLikeService,
                          IUserInfoService userInfoService,
                          IImageService imageService) {
        this.postService = postService;
        this.postReplyService = postReplyService;
        this.postLikeService = postLikeService;
        this.userInfoService = userInfoService;
        this.imageService = imageService;
    }

    @GetMapping("{id}")
    public PostDTO getPostById(@PathVariable(name = "id") String postId) {
        Post post = postService.getById(postId);
        PostReply replyExample = new PostReply();
        replyExample.setPostId(postId);
        List<PostReply> postReplies = postReplyService.findAll(Example.of(replyExample), Sort.by(Sort.Direction.ASC, "createTime"));
        PostDTO dto = model2dto(post, PostDTO.class);
        List<PostReplyDTO> replyDTOS = model2dto(postReplies, PostReplyDTO.class);
        dto.setReplies(replyDTOS);
        return dto;
    }

    @PostMapping("")
    public PostDTO createPost(@RequestBody PostDTO dto) {
        if (!StringUtils.hasText(dto.getAudioUrl()) && !StringUtils.hasText(dto.getVideoUrl()) &&
                !CollectionUtils.isEmpty(dto.getImageUrls()) && !StringUtils.hasText(dto.getContent())
        ) {
            throw new BusinessException("Post can not be empty.");
        }
        Post model = new Post();
        BeanUtils.copyProperties(dto, model);
        model.setLikeCount(0);
        model.setReplyCount(0);
        model.setImageIds(String.join(",", dto.getImageUrls()));
        model.setUserId(ReqInfoOperator.get().getUserId().get());
        postService.insert(model);
        return model2dto(model, PostDTO.class);
    }

    @PostMapping("like/{id}")
    public PostDTO likeOrUnlike(@PathVariable(name = "id") String postId) {
        Post model = postService.getById(postId);
        PostLike postLike = postLikeService.likeOrUnlike(postId, ReqInfoOperator.get().getUserId().get());
        if (postLike != null) {
            model.setLikeCount(model.getLikeCount() + 1);
        } else {
            model.setLikeCount(model.getLikeCount() - 1);
        }
        postService.update(model);
        PostDTO dto = model2dto(model, PostDTO.class);
        fillPostDto(dto);
        dto.setLike(postLike != null);
        return dto;
    }

    @GetMapping("")
    public PageResponse<PostDTO> searchPage(@RequestParam(name = "type") PostSearchType type,
                                            PageRequest pageRequest) {
        return switch (type) {
            case FOCUS -> searchPageFocus(pageRequest);
            case VOICE -> searchPageVoice(pageRequest);
            case LATEST -> searchPageByTime(pageRequest);
            case RANDOM -> searchPageRandom(pageRequest);
        };
    }

    private void fillPostDto(PostDTO dto) {
        UserInfo userInfo = userInfoService.getById(dto.getUserId());
        dto.setUserInfo(model2dto(userInfo, UserInfoDTO.class));
        if (StringUtils.hasText(dto.getImageIds())) {
            List<String> imageIds = Arrays.stream(dto.getImageIds().split(",")).toList();
            List<Image> images = imageService.findAllById(imageIds);
            Map<String, Image> imageMap = images.stream().collect(
                    Collectors.toMap(Image::getId, a -> a, (k1, k2) -> k1)
            );
            List<String> imageUrls = new LinkedList<>();
            for (String imageId : imageIds) {
                imageUrls.add(imageMap.get(imageId).getUrl());
            }
            dto.setImageUrls(imageUrls);
        }
        dto.setUserId(null);
        dto.setImageIds(null);
    }

    private void fillPostPageDto(PageResponse<PostDTO> dtoPageResponse) {
        Set<String> userIds = dtoPageResponse.getRows().stream().map(PostDTO::getUserId).collect(Collectors.toSet());
        List<UserInfo> userInfos = userInfoService.findAllById(userIds);
        List<UserInfoDTO> userInfoDTOS = model2dto(userInfos, UserInfoDTO.class);
        Map<String, UserInfoDTO> userInfoDTOMap = userInfoDTOS.stream().collect(
                Collectors.toMap(UserInfoDTO::getId, a -> a, (k1, k2) -> k1)
        );
        Set<String> postIds = dtoPageResponse.getRows().stream().map(PostDTO::getId).collect(Collectors.toSet());
        List<PostLike> postLikes = postLikeService.searchByPostIds(postIds, ReqInfoOperator.get().getUserId().get());
        Set<String> likePostIds = postLikes.stream().map(PostLike::getPostId).collect(Collectors.toSet());
        List<PostDTO> postDTOS = dtoPageResponse.getRows();

        String postImageIds = postDTOS.stream()
                .map(PostDTO::getImageIds)
                .filter(str -> !str.isEmpty())
                .collect(Collectors.joining(","));
        Map<String, Image> imageMap = new HashMap<>();
        if (StringUtils.hasText(postImageIds)) {
            List<String> allImageIds = Arrays.stream(postImageIds.split(",")).toList();
            List<Image> images = imageService.findAllById(allImageIds);
            imageMap.putAll(images.stream().collect(
                    Collectors.toMap(Image::getId, a -> a, (k1, k2) -> k1)
            ));
        }
        for (PostDTO dto : postDTOS) {
            dto.setUserInfo(userInfoDTOMap.get(dto.getUserId()));
            dto.setLike(likePostIds.contains(dto.getId()));
            fillPostImages(dto, imageMap);
            dto.setUserId(null);
            dto.setImageIds(null);
        }
        dtoPageResponse.setRows(postDTOS);
    }

    private void fillPostImages(PostDTO dto, Map<String, Image> imageMap) {
        if (StringUtils.hasText(dto.getImageIds())) {
            List<String> imageIds = Arrays.stream(dto.getImageIds().split(",")).toList();
            List<String> imageUrls = new LinkedList<>();
            for (String imageId : imageIds) {
                imageUrls.add(imageMap.get(imageId).getUrl());
            }
            dto.setImageUrls(imageUrls);
        }
    }

    private PageResponse<PostDTO> searchPageRandom(PageRequest pageRequest) {
        Page<Post> modelPage = postService.searchPageRandom(pageRequest.getPageIndex(), pageRequest.getPageSize());
        PageResponse<PostDTO> dto = model2dto(modelPage, PostDTO.class);
        dto.setPage(pageRequest.getPageIndex() + 2);
        fillPostPageDto(dto);
        return dto;
    }

    private PageResponse<PostDTO> searchPageByTime(PageRequest pageRequest) {
        Page<Post> modelPage = postService.searchPageByTime(pageRequest.getPageIndex(), pageRequest.getPageSize());
        PageResponse<PostDTO> dto = model2dto(modelPage, PostDTO.class);
        dto.setPage(pageRequest.getPageIndex() + 2);
        fillPostPageDto(dto);
        return dto;
    }

    private PageResponse<PostDTO> searchPageVoice(PageRequest pageRequest) {
        Page<Post> modelPage = postService.searchPageVoice(pageRequest.getPageIndex(), pageRequest.getPageSize());
        PageResponse<PostDTO> dto = model2dto(modelPage, PostDTO.class);
        dto.setPage(pageRequest.getPageIndex() + 2);
        fillPostPageDto(dto);
        return dto;
    }

    private PageResponse<PostDTO> searchPageFocus(PageRequest pageRequest) {
        Page<Post> modelPage = postService.searchPageFocus(pageRequest.getPageIndex(), pageRequest.getPageSize());
        PageResponse<PostDTO> dto = model2dto(modelPage, PostDTO.class);
        dto.setPage(pageRequest.getPageIndex() + 2);
        fillPostPageDto(dto);
        return dto;
    }
}
