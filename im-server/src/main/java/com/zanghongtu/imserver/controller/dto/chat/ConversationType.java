package com.zanghongtu.imserver.controller.dto.chat;

import lombok.Getter;

@Getter
public enum ConversationType {
    PERSON(0),
    GROUP(1),
    SYSTEM(2),
    ;

    final int code;

    ConversationType(int code) {
        this.code = code;
    }
}
