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
@Table(name = "conversation_user")
public class ConversationUser extends BaseEntity {

    @Column(nullable = false)
    private String conversationId;

    @Column(nullable = false)
    private String userId;

    @Column(columnDefinition = "tinyint(1) DEFAULT 0")
    private Boolean onTop;

    private String avatar;

    private String nickName;

    private ConversationType type;

}
