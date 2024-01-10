package com.zanghongtu.imserver.exception;

import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class BaseException extends RuntimeException {

    private Integer errorCode;

    public BaseException(BaseErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode.getCode();
    }

    public BaseException(String message) {
        super(message);
        this.errorCode = BaseErrorCode.ERROR.getCode();
    }

    public BaseException(BaseErrorCode errorCode, String message) {
        super(message);
        this.errorCode = errorCode.getCode();
    }

    public BaseException(BaseErrorCode errorCode, String message, Throwable throwable) {
        super(message, throwable);
        this.errorCode = errorCode.getCode();
    }

    public BaseException(Integer errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }

    public BaseException(Integer errorCode, String message, Throwable throwable) {
        super(message, throwable);
        this.errorCode = errorCode;
    }

}
