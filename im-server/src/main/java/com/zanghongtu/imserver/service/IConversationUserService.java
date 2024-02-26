package com.zanghongtu.imserver.service;


import com.zanghongtu.imserver.model.ConversationUser;

import java.util.List;

public interface IConversationUserService extends IBaseService<ConversationUser, String> {

    List<ConversationUser> listByConversationId(String conversationId);

    List<ConversationUser> listByUserId(String userId);
}
