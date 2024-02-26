package com.zanghongtu.imserver.controller.dto.chat;

import lombok.Data;

@Data
public class AdditionalInfoDTO {
    /**
     *     "recall_info": {
     *       "recall_allowed": true,
     *       "recall_deadline": "2024-01-05T12:00:00Z"
     *     }
     */
    private String replyToMessageId;
}
