package com.zanghongtu.imserver.repository;

import com.zanghongtu.imserver.model.ConversationUser;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;

public interface ConversationUserRepository extends JpaRepositoryImplementation<ConversationUser, String> {

}