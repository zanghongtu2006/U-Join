package com.zanghongtu.imserver.model;

import com.zanghongtu.imserver.controller.dto.chat.ConversationType;
import com.zanghongtu.imserver.controller.dto.user.Gender;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;
import java.util.Set;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "conversation")
public class Conversation extends BaseEntity {

    @Column(length = 64)
    private String conversationId;

    @Column(length = 17)
    private String shortConversationId;

    @Column
    private Integer unReadCount;

    @Column(columnDefinition = "TEXT")
    private String lastMessage;

    @Column
    private Date lastUpdateTime;

}
