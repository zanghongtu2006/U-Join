package com.zanghongtu.imserver.controller.dto.user;

import lombok.Getter;

@Getter
public enum UserType {
    ADMIN(0),
    CLIENT(1),
    USER(2);

    private final Integer code;

    UserType(Integer code) {
        this.code = code;
    }
}
