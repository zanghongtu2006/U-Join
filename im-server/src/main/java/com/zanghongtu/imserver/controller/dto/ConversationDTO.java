package com.zanghongtu.imserver.controller.dto;

import com.zanghongtu.imserver.controller.dto.chat.ConversationType;
import lombok.Data;

import java.util.Set;

@Data
public class ConversationDTO {
    private String conversationId;

    private String shortConversationId;

    private String avatar;

    private String nickName;

    private Integer unReadCount;

    private String lastMessage;

    private Set<String> userIds;

    private ConversationType type;
}
