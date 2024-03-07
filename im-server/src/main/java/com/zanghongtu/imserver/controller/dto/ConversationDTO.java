package com.zanghongtu.imserver.controller.dto;

import com.zanghongtu.imserver.controller.dto.chat.ConversationType;
import com.zanghongtu.imserver.controller.dto.user.Gender;
import lombok.Data;

import java.util.Date;
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

    private Gender gender;

    private ConversationType type;

    private Date lastUpdateTime;
}
