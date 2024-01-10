package com.zanghongtu.imserver.service.aop;

import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
public class ControllerAOP {

    @Pointcut("execution(public * com.zanghongtu..*.controller..*.*(..))")
    public void controllerMethod() {

    }

    @Around("controllerMethod()")
    public Object handleControllerMethod(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();
        try {
            Object obj = proceedingJoinPoint.proceed();
            log.info(proceedingJoinPoint.getSignature() + "use time:" + (System.currentTimeMillis() - startTime));
            return obj;
        } catch (Throwable throwable) {
            log.error("Execute " + proceedingJoinPoint.getSignature() + " failed.", throwable);
            throw throwable;
        } finally {
            ReqInfoOperator.remove();
        }
    }

}
