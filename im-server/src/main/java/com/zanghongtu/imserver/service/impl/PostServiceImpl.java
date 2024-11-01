package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.DictItem;
import com.zanghongtu.imserver.model.Post;
import com.zanghongtu.imserver.repository.DictItemRepository;
import com.zanghongtu.imserver.repository.PostRepository;
import com.zanghongtu.imserver.service.IDictItemService;
import com.zanghongtu.imserver.service.IPostService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.data.redis.connection.SortParameters;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;

@Slf4j
@Service
public class PostServiceImpl extends BaseServiceImpl<Post, String> implements IPostService {
    @Autowired
    private PostRepository repository;

    public PostServiceImpl(JpaRepositoryImplementation<Post, String> repository) {
        super(repository);
    }

    @Override
    public Page<Post> searchPageRandom(Integer pageIndex, Integer pageSize) {
        List<Post> postList = repository.findRandomRecords(pageSize);
        PageRequest pageRequest = PageRequest.of(pageIndex, pageSize);
        return new PageImpl<>(postList, pageRequest, Long.MAX_VALUE);
    }

    @Override
    public Page<Post> searchPageByTime(Integer pageIndex, Integer pageSize) {
        Specification<Post> spec = (root, query, criteriaBuilder) -> criteriaBuilder.isNull(root.get("audioId"));
        return search(spec, Sort.by(Sort.Direction.DESC, "createTime"), pageIndex, pageSize);
    }

    @Override
    public Page<Post> searchPageVoice(Integer pageIndex, Integer pageSize) {
        Specification<Post> spec = (root, query, criteriaBuilder) -> criteriaBuilder.isNotNull(root.get("audioId"));
        return search(spec, Sort.by(Sort.Direction.DESC, "createTime"), pageIndex, pageSize);
    }

    @Override
    public Page<Post> searchPageFocus(Integer pageIndex, Integer pageSize) {
        return new PageImpl<>(new LinkedList<>(), Pageable.ofSize(pageSize), 0L);
    }
}
