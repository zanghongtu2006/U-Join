package com.zanghongtu.imserver.model;

import com.zanghongtu.imserver.controller.dto.chat.ConversationType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "conversation")
public class Conversation extends BaseEntity {

    @Column(length = 64)
    private String conversationId;

    @Column(length = 17)
    private String shortConversationId;

}
