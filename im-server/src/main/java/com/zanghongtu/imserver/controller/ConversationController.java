package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.ConversationDTO;
import com.zanghongtu.imserver.controller.dto.chat.ConversationType;
import com.zanghongtu.imserver.controller.dto.page.PageRequest;
import com.zanghongtu.imserver.controller.dto.page.PageResponse;
import com.zanghongtu.imserver.controller.dto.user.Gender;
import com.zanghongtu.imserver.exception.PermitException;
import com.zanghongtu.imserver.model.Conversation;
import com.zanghongtu.imserver.model.ConversationUser;
import com.zanghongtu.imserver.model.UserInfo;
import com.zanghongtu.imserver.service.IConversationService;
import com.zanghongtu.imserver.service.IConversationUserService;
import com.zanghongtu.imserver.service.IUserInfoService;
import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import jakarta.persistence.criteria.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequestMapping(path = "conversations")
public class ConversationController extends BaseController {
    private final IConversationService conversationService;

    private final IConversationUserService conversationUserService;

    private final IUserInfoService userInfoService;

    @Autowired
    public ConversationController(IConversationService conversationService,
                                  IConversationUserService conversationUserService,
                                  IUserInfoService userInfoService) {
        this.conversationService = conversationService;
        this.conversationUserService = conversationUserService;
        this.userInfoService = userInfoService;
    }

    @PostMapping(path = "")
    public ConversationDTO createConversation(@RequestBody ConversationDTO dto) {
        Optional<Conversation> existed = conversationService.getByConversationId(dto.getConversationId());
        if (existed.isPresent()) {
            return model2dto(existed.get(), ConversationDTO.class);
        }
        Conversation conversation = new Conversation();
        BeanUtils.copyProperties(dto, conversation);
        Conversation model = conversationService.insert(conversation);
        for (String uid : dto.getUserIds()) {
            ConversationUser conversationUser = new ConversationUser();
            conversationUser.setUserId(uid);
            conversationUser.setConversationId(dto.getConversationId());
            conversationUser.setAvatar(dto.getAvatar());
            conversationUser.setNickName(dto.getNickName());
            conversationUser.setType(dto.getType());
            conversationUserService.insert(conversationUser);
        }
        return model2dto(model, ConversationDTO.class);
    }

    @GetMapping(path = "latest")
    public PageResponse<ConversationDTO> latestConversations(PageRequest pageRequest) {
        Optional<String> uid = ReqInfoOperator.get().getUserId();
        if (uid.isEmpty()) {
            throw new PermitException("用户不存在");
        }
        List<ConversationUser> conversationUsers = new LinkedList<>();
        //第一页，先查询所有置顶
        if (pageRequest.getPageIndex() == 0) {
            ConversationUser systemExample = new ConversationUser();
            systemExample.setType(ConversationType.SYSTEM);
            systemExample.setUserId(uid.get());
            conversationUsers.addAll(conversationUserService.findAll(Example.of(systemExample)));

            ConversationUser onTopExample = new ConversationUser();
            onTopExample.setUserId(uid.get());
            onTopExample.setOnTop(true);
            conversationUsers.addAll(conversationUserService.findAll(Example.of(onTopExample)));
        }
        Specification<ConversationUser> spec = (root, criteriaQuery, criteriaBuilder) -> {
            Predicate p1 = criteriaBuilder.equal(root.get("userId"), uid.get());
            Predicate p2 = criteriaBuilder.equal(root.get("onTop"), false);
            Predicate p3 = criteriaBuilder.notEqual(root.get("type"), ConversationType.SYSTEM);
            Predicate p = criteriaBuilder.and(p1);
            p = criteriaBuilder.and(p, p2);
            p = criteriaBuilder.and(p, p3);
            return p;
        };
        Page<ConversationUser> conversationUserPage =
                conversationUserService.search(spec, pageRequest.getPageIndex(), pageRequest.getPageSize());
        conversationUsers.addAll(conversationUserPage.getContent());
        PageResponse<ConversationDTO> response = model2dto(conversationUserPage, ConversationDTO.class);
        response.setRows(model2dto(conversationUsers));
        return response;
    }

    private List<ConversationDTO> model2dto(List<ConversationUser> models) {
        Set<String> conversationIds = models.stream().map(ConversationUser::getConversationId).collect(Collectors.toSet());
        Specification<ConversationUser> spec = (root, criteriaQuery, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(root.get("conversationId").in(conversationIds));
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
        List<ConversationUser> conversationUsers = conversationUserService.findAll(spec);
        Map<String, Set<String>> conversationIdToUids = conversationUsers.stream()
                .collect(Collectors.groupingBy(ConversationUser::getConversationId,
                        Collectors.mapping(ConversationUser::getUserId, Collectors.toSet())));
        List<UserInfo> users = userInfoService.findAllById(conversationUsers.stream().map(ConversationUser::getUserId).collect(Collectors.toSet()));
        Map<String, UserInfo> userInfoMap = users.stream().collect(
                Collectors.toMap(UserInfo::getId, a -> a, (k1, k2) -> k1)
        );
        List<Conversation> conversations = conversationService.findAllByConversationIds(
                conversationUsers.stream().map(ConversationUser::getConversationId).collect(Collectors.toSet())
        );
        Map<String, Conversation> conversationMap = conversations.stream().collect(
                Collectors.toMap(Conversation::getConversationId, a -> a, (k1, k2) -> k1)
        );
        List<ConversationDTO> dtos = new LinkedList<>();
        for (ConversationUser model : models) {
            dtos.add(model2dto(model, conversationMap.get(model.getConversationId()),
                    conversationIdToUids.get(model.getConversationId()), userInfoMap));
        }
        return dtos;
    }

    private ConversationDTO model2dto(ConversationUser conversationUser, Conversation conversation,
                                      Set<String> userIds, Map<String, UserInfo> userInfoMap) {
        ConversationDTO dto = new ConversationDTO();
        dto.setConversationId(conversation.getConversationId());
        dto.setShortConversationId(conversation.getShortConversationId());
        dto.setLastMessage(conversation.getLastMessage()==null?"":conversation.getLastMessage());
        dto.setUnReadCount(conversation.getUnReadCount()==null?0:conversation.getUnReadCount());
        dto.setLastUpdateTime(conversation.getLastUpdateTime());
        dto.setUserIds(userIds);
        dto.setType(conversationUser.getType());
        if (conversationUser.getType() == ConversationType.PERSON) {
            Optional<String> myUid = ReqInfoOperator.get().getUserId();
            if (myUid.isPresent()) {
                for (String uid : userIds) {
                    if (!myUid.get().equals(uid)) {
                        dto.setGender(userInfoMap.get(uid).getGender());
                        dto.setAvatar(userInfoMap.get(uid).getAvatar());
                        dto.setNickName(userInfoMap.get(uid).getNickName());
                    }
                }
            }
        } else if (conversationUser.getType() == ConversationType.SYSTEM) {
            Optional<String> myUid = ReqInfoOperator.get().getUserId();
            if (myUid.isPresent()) {
                for (String uid : userIds) {
                    if (!myUid.get().equals(uid)) {
                        dto.setGender(Gender.FEMALE);
                        dto.setAvatar(userInfoMap.get(uid).getAvatar());
                        dto.setNickName(userInfoMap.get(uid).getNickName());
                    }
                }
            }
        }
        return dto;
    }

}


