package com.zanghongtu.imserver.controller.dto.chat;

import com.zanghongtu.imserver.controller.dto.ConversationDTO;
import lombok.Data;

@Data
public class ChatDTO {
    /**
     * UUID_uid_randomInt
     */
    private String messageId;

    private UserDTO sender;

    private UserDTO recver;

    private String senderId;

    private String conversationId;

    private String shortConversationId;

    private ContentDTO content;

    private Long timestamp;

    private MessageType messageType;

    private StatusDTO status;

    private AdditionalInfoDTO additionalInfo;

    private ConversationDTO conversationDTO;
}
