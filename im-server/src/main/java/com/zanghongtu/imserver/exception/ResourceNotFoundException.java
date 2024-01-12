package com.zanghongtu.imserver.exception;

import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;

public class ResourceNotFoundException extends BaseException {
    public ResourceNotFoundException() {
        super(BaseErrorCode.RESOURCE_NOT_FOUND);
    }

    public ResourceNotFoundException(String message) {
        super(BaseErrorCode.RESOURCE_NOT_FOUND, message);
    }

    public ResourceNotFoundException(Integer errorCode, String message) {
        super(errorCode, message);
    }
}