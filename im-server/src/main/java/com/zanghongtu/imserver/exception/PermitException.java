package com.zanghongtu.imserver.exception;

import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;

public class PermitException extends BaseException {
    public PermitException() {
        super(BaseErrorCode.USER_NOT_PERMITTED);
    }

    public PermitException(String message) {
        super(BaseErrorCode.USER_NOT_PERMITTED, message);
    }

    public PermitException(Integer errorCode, String message) {
        super(errorCode, message);
    }
}

