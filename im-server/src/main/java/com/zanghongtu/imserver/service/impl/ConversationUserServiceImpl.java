package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.ConversationUser;
import com.zanghongtu.imserver.repository.ConversationUserRepository;
import com.zanghongtu.imserver.service.IConversationUserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class ConversationUserServiceImpl extends BaseServiceImpl<ConversationUser, String> implements IConversationUserService {
    @Autowired
    private ConversationUserRepository repository;

    public ConversationUserServiceImpl(JpaRepositoryImplementation<ConversationUser, String> repository) {
        super(repository);
    }

    @Override
    public List<ConversationUser> listByConversationId(String conversationId) {
        ConversationUser example = new ConversationUser();
        example.setConversationId(conversationId);
        return findAll(Example.of(example));
    }

    @Override
    public List<ConversationUser> listByUserId(String userId) {
        ConversationUser example = new ConversationUser();
        example.setUserId(userId);
        return findAll(Example.of(example));
    }
}
