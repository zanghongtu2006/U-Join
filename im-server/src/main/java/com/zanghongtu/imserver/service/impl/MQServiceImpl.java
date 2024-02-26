package com.zanghongtu.imserver.service.impl;

import com.alibaba.fastjson.JSON;
import com.zanghongtu.imserver.config.MQConfig;
import com.zanghongtu.imserver.controller.dto.chat.ChatDTO;
import com.zanghongtu.imserver.model.ConversationUser;
import com.zanghongtu.imserver.service.IConversationUserService;
import com.zanghongtu.imserver.service.IMQService;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.spring.core.RocketMQTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
public class MQServiceImpl implements IMQService {
    @Autowired
    private RocketMQTemplate rocketMQTemplate;

    @Autowired
    private IConversationUserService conversationUserService;

    @Autowired
    private MQConfig mqConfig;

    @Override
    public void sendChatMessage(ChatDTO chatDTO) {
        List<ConversationUser> conversationUsers = conversationUserService.listByConversationId(chatDTO.getConversationId());
        Set<String> userIds = conversationUsers.stream().map(ConversationUser::getUserId).collect(Collectors.toSet());
        for (String userId : userIds) {
            String topic = mqConfig.getTopic(chatDTO.getConversationId()) + ":" + userId;
            try {
                rocketMQTemplate.convertAndSend(topic, JSON.toJSONString(chatDTO));
            } catch (Exception e) {
                log.error("Send msg to mq failed.", e);
            }
        }
    }
}
