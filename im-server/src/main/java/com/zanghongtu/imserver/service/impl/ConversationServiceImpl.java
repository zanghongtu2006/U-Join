package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.Conversation;
import com.zanghongtu.imserver.repository.ConversationRepository;
import com.zanghongtu.imserver.service.IConversationService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class ConversationServiceImpl extends BaseServiceImpl<Conversation, String> implements IConversationService {
    @Autowired
    private ConversationRepository repository;

    public ConversationServiceImpl(JpaRepositoryImplementation<Conversation, String> repository) {
        super(repository);
    }

}
