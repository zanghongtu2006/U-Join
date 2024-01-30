package com.zanghongtu.imserver.controller.dto.user;

import lombok.Getter;

@Getter
public enum UserStatus {

    REGISTERD(0),
    PROFILE_FILLED(1),
    REAL_NAME(2),
    REAL_PIC_UPLOADED(3);

    private final Integer code;
    UserStatus(Integer code) {
        this.code = code;
    }

}
