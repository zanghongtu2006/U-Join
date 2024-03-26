package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.PostLike;
import com.zanghongtu.imserver.repository.PostLikeRepository;
import com.zanghongtu.imserver.service.IPostLikeService;
import jakarta.persistence.criteria.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Slf4j
@Service
public class PostLikeServiceImpl extends BaseServiceImpl<PostLike, String> implements IPostLikeService {
    @Autowired
    private PostLikeRepository repository;

    public PostLikeServiceImpl(JpaRepositoryImplementation<PostLike, String> repository) {
        super(repository);
    }

    @Override
    public PostLike likeOrUnlike(String postId, String userId) {
        PostLike example = new PostLike();
        example.setPostId(postId);
        example.setUserId(userId);
        List<PostLike> postLikes = findAll(Example.of(example));
        if (!CollectionUtils.isEmpty(postLikes)) {
            //删除所有like
            deleteAll(postLikes);
            return null;
        } else {
            PostLike postLike = new PostLike();
            postLike.setPostId(postId);
            postLike.setUserId(userId);
            return insert(postLike);
        }
    }

    @Override
    public List<PostLike> searchByPostIds(Set<String> postIds, String userId) {
        Specification<PostLike> itemSpec = (root, criteriaQuery, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(root.get("postId").in(postIds));
            Predicate predicate = criteriaBuilder.equal(root.get("userId"), userId);
            predicates.add(predicate);
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
        return findAll(itemSpec);
    }
}
