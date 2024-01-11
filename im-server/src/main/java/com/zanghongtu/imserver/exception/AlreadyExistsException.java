package com.zanghongtu.imserver.exception;

import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;

public class AlreadyExistsException extends BaseException {
    public AlreadyExistsException() {
        super(BaseErrorCode.ALREADY_EXSISTS);
    }

    public AlreadyExistsException(String message) {
        super(BaseErrorCode.ALREADY_EXSISTS, message);
    }

    public AlreadyExistsException(Integer errorCode, String message) {
        super(errorCode, message);
    }
}