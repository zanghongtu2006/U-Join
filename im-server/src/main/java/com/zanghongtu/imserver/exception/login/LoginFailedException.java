package com.zanghongtu.imserver.exception.login;

import com.zanghongtu.imserver.exception.BaseException;
import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;

public class LoginFailedException extends BaseException {
    public LoginFailedException() {
        super(BaseErrorCode.LOGIN_FAILED);
    }

    public LoginFailedException(String message) {
        super(BaseErrorCode.LOGIN_FAILED, message);
    }

    public LoginFailedException(Integer errorCode, String message) {
        super(errorCode, message);
    }
}

