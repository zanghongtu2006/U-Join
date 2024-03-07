package com.zanghongtu.imserver.service;


import com.zanghongtu.imserver.model.Conversation;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface IConversationService extends IBaseService<Conversation, String> {

    Optional<Conversation> getByConversationId(String conversationId);

    List<Conversation> findAllByConversationIds(Set<String> collect);
}
