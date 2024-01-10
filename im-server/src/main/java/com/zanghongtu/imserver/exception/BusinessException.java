package com.zanghongtu.imserver.exception;

import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;

public class BusinessException extends BaseException {
    public BusinessException() {
        super(BaseErrorCode.FAILED);
    }

    public BusinessException(String message) {
        super(BaseErrorCode.FAILED, message);
    }

    public BusinessException(Integer errorCode, String message) {
        super(errorCode, message);
    }
}
