package com.zanghongtu.imserver.exception;

import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;

public class FileTypeException extends BaseException {
    public FileTypeException() {
        super(BaseErrorCode.FILE_TYPE_ERROR);
    }

    public FileTypeException(String message) {
        super(BaseErrorCode.FILE_TYPE_ERROR, message);
    }

    public FileTypeException(Integer errorCode, String message) {
        super(errorCode, message);
    }
}
