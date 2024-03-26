package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.PostReply;
import com.zanghongtu.imserver.repository.PostReplyRepository;
import com.zanghongtu.imserver.service.IPostReplyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class PostReplyServiceImpl extends BaseServiceImpl<PostReply, String> implements IPostReplyService {
    @Autowired
    private PostReplyRepository repository;

    public PostReplyServiceImpl(JpaRepositoryImplementation<PostReply, String> repository) {
        super(repository);
    }

}
