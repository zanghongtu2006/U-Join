package com.zanghongtu.imserver.controller.dto;

import lombok.Data;

@Data
public class ConversationDTO {
    private String conversationId;

    private String shortConversationId;

    private String avatar;

    private String nickName;

    private Integer unReadCount;

    private String lastMessage;
}
