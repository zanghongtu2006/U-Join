package com.zanghongtu.imserver.exception;

import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;

public class CheckException extends BaseException {
    public CheckException() {
        super(BaseErrorCode.CHECK_ERROR);
    }

    public CheckException(String message) {
        super(BaseErrorCode.CHECK_ERROR, message);
    }

    public CheckException(String message, Throwable throwable) {
        super(BaseErrorCode.CHECK_ERROR, message, throwable);
    }

    public CheckException(Integer code, String message) {
        super(code, message);
    }
}
