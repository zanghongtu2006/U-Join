package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.controller.dto.chat.ConversationType;
import com.zanghongtu.imserver.controller.dto.user.UserStatus;
import com.zanghongtu.imserver.model.Conversation;
import com.zanghongtu.imserver.model.ConversationUser;
import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.model.UserInfo;
import com.zanghongtu.imserver.service.IConversationService;
import com.zanghongtu.imserver.service.IConversationUserService;
import com.zanghongtu.imserver.service.IRegisterService;
import com.zanghongtu.imserver.service.IUserInfoService;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RegisterServiceImpl implements IRegisterService {
    private final IUserInfoService userInfoService;

    private final IConversationService conversationService;

    private final IConversationUserService conversationUserService;

    @Autowired
    public RegisterServiceImpl(IUserInfoService userInfoService,
                               IConversationService conversationService,
                               IConversationUserService conversationUserService) {
        this.userInfoService = userInfoService;
        this.conversationService = conversationService;
        this.conversationUserService = conversationUserService;
    }

    @Override
    public UserInfo register(String userName, User newUser) {
        UserInfo userInfo = new UserInfo();
        userInfo.setAuthUserId(newUser.getId());
        userInfo.setFullName(userName);
        userInfo.setStatus(UserStatus.REGISTERD);
        userInfo.setAvatar("https://placekitten.com/200/200");
        userInfoService.insert(userInfo);
        createClientConversation(userInfo);

        return userInfo;
    }

    @Transactional(rollbackOn = Exception.class)
    private void createClientConversation(UserInfo userInfo) {
        // 创建第一个对话：用户-客服
        UserInfo client = userInfoService.getClient();
        String shortConversationId = "";
        String conversationId = "";
        if (client.getId().compareTo(userInfo.getId()) < 0) {
            conversationId += client.getId().replace("-", "") + userInfo.getId().replace("-", "");
            shortConversationId += client.getId().substring(0, 8) + userInfo.getId().substring(0, 8);
        } else {
            conversationId += userInfo.getId().replace("-", "") + client.getId().replace("-", "");
            shortConversationId += userInfo.getId().substring(0, 8) + client.getId().substring(0, 8);
        }
        Conversation conversation = new Conversation();
        conversation.setConversationId(conversationId);
        conversation.setShortConversationId(shortConversationId);
        conversationService.insert(conversation);

        ConversationUser conversationUser = new ConversationUser();
        conversationUser.setConversationId(conversationId);
        conversationUser.setUserId(userInfo.getId());
        conversationUser.setType(ConversationType.SYSTEM);
        conversationUser.setOnTop(false);
        conversationUser.setNickName(client.getNickName());
        conversationUser.setAvatar(client.getAvatar());
        conversationUserService.insert(conversationUser);

        ConversationUser clientConversation = new ConversationUser();
        clientConversation.setConversationId(conversationId);
        clientConversation.setUserId(client.getId());
        clientConversation.setType(ConversationType.PERSON);
        clientConversation.setAvatar(userInfo.getAvatar());
        clientConversation.setNickName(userInfo.getNickName());
        clientConversation.setOnTop(false);
        conversationUserService.insert(clientConversation);
    }
}
