package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.ConversationUser;
import com.zanghongtu.imserver.repository.ConversationUserRepository;
import com.zanghongtu.imserver.service.IConversationUserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class ConversationUserServiceImpl extends BaseServiceImpl<ConversationUser, String> implements IConversationUserService {
    @Autowired
    private ConversationUserRepository repository;

    public ConversationUserServiceImpl(JpaRepositoryImplementation<ConversationUser, String> repository) {
        super(repository);
    }

}
