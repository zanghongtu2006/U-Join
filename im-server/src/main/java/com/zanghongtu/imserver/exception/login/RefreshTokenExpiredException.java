package com.zanghongtu.imserver.exception.login;

import com.zanghongtu.imserver.exception.BaseException;
import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;

public class RefreshTokenExpiredException extends BaseException {

    public RefreshTokenExpiredException() {
        super(BaseErrorCode.REFRESH_TOKEN_EXPIRED);
    }

    public RefreshTokenExpiredException(String message) {
        super(BaseErrorCode.REFRESH_TOKEN_EXPIRED, message);
    }

    public RefreshTokenExpiredException(Integer errorCode, String message) {
        super(errorCode, message);
    }
}
