package com.zanghongtu.imserver.service.aop;

import com.zanghongtu.imserver.service.aop.dto.BaseDTO;
import com.zanghongtu.imserver.service.aop.dto.BaseErrorCode;
import com.zanghongtu.imserver.threadlocal.ReqInfo;
import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import java.lang.reflect.AnnotatedElement;
import java.util.Arrays;

@ControllerAdvice(value = "com.zanghongtu")
public class ApiResponseHandler implements ResponseBodyAdvice {

    private static final Class[] ANNOS = {
            RequestMapping.class,
            GetMapping.class,
            PostMapping.class,
            DeleteMapping.class,
            PutMapping.class,
            PatchMapping.class
    };

    @Override
    public boolean supports(MethodParameter returnType, Class aClass) {
        AnnotatedElement element = returnType.getAnnotatedElement();
        return Arrays.stream(ANNOS).anyMatch(anno -> anno.isAnnotation() && element.isAnnotationPresent(anno));
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType mediaType,
                                  Class aClass, ServerHttpRequest request, ServerHttpResponse response) {
        ReqInfo reqInfo = ReqInfoOperator.get();
        if (reqInfo != null && reqInfo.getErrorCode() != BaseErrorCode.SUCCESS.getCode()) {
            return new BaseDTO<>(BaseErrorCode.FAILED.getCode(), reqInfo.getErrorMsg());
        } else if (body instanceof String) {
            return body;
        } else {
            BaseDTO<Object> baseDTO = new BaseDTO<>(BaseErrorCode.SUCCESS);
            baseDTO.setData(body);
            return baseDTO;
        }
    }

}
