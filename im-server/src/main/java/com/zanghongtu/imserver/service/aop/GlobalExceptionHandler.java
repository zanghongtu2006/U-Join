package com.zanghongtu.imserver.service.aop;

import com.zanghongtu.imserver.exception.BaseException;
import com.zanghongtu.imserver.exception.BusinessException;
import com.zanghongtu.imserver.exception.CheckException;
import com.zanghongtu.imserver.exception.PermitException;
import com.zanghongtu.imserver.exception.login.InvalidTokenExpiredException;
import com.zanghongtu.imserver.exception.login.RefreshTokenExpiredException;
import com.zanghongtu.imserver.service.aop.dto.BaseDTO;
import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;
import com.zanghongtu.imserver.threadlocal.ReqInfo;
import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Object> customException(Exception e) {
        ReqInfo reqInfo = ReqInfoOperator.get();
        if (reqInfo == null) {
            reqInfo = new ReqInfo();
        }
        reqInfo.setErrorCode(500);
        reqInfo.setErrorMsg(e.getMessage());
        ReqInfoOperator.set(reqInfo);
        log.error("RequestId: " + reqInfo.getRequestId() + "Exec failed ", e);
        BaseDTO<?> errorResponse;
        if (e instanceof BusinessException) {
            errorResponse = new BaseDTO<>(BaseErrorCode.FAILED);
            return new ResponseEntity<>(errorResponse, HttpStatus.OK);
        } else if (e instanceof CheckException) {
            errorResponse = new BaseDTO<>(BaseErrorCode.CHECK_ERROR);
            return new ResponseEntity<>(errorResponse, HttpStatus.OK);
        } else if (e instanceof PermitException) {
            errorResponse = new BaseDTO<>(BaseErrorCode.USER_NOT_PERMITTED);
            return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
        } else if (e instanceof RefreshTokenExpiredException) {
            errorResponse = new BaseDTO<>(BaseErrorCode.REFRESH_TOKEN_EXPIRED);
            return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
        } else if (e instanceof InvalidTokenExpiredException) {
            errorResponse = new BaseDTO<>(BaseErrorCode.TOKEN_EXPIRED);
            return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
        } else if (e instanceof BaseException) {
            errorResponse = new BaseDTO<>(((BaseException) e).getErrorCode(), e.getMessage());
            return new ResponseEntity<>(errorResponse, HttpStatus.OK);
        } else {
            //TODO 未知的异常，应该格外注意，可以发送邮件通知等
            errorResponse = new BaseDTO<>(BaseErrorCode.ERROR);
            return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    static class ErrorResponse {
        private HttpStatus status;
        private String message;

        public ErrorResponse(HttpStatus status, String message) {
            this.status = status;
            this.message = message;
        }
        // Getters and Setters
    }
}
