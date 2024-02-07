package com.zanghongtu.imserver.repository;

import com.zanghongtu.imserver.model.Conversation;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;

public interface ConversationRepository extends JpaRepositoryImplementation<Conversation, String> {

}