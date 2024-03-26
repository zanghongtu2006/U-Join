package com.zanghongtu.imserver.exception.login;

import com.zanghongtu.imserver.exception.BaseException;
import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;

public class InvalidTokenExpiredException extends BaseException {

    public InvalidTokenExpiredException() {
        super(BaseErrorCode.TOKEN_EXPIRED);
    }

    public InvalidTokenExpiredException(String message) {
        super(BaseErrorCode.TOKEN_EXPIRED, message);
    }

    public InvalidTokenExpiredException(Integer errorCode, String message) {
        super(errorCode, message);
    }
}
