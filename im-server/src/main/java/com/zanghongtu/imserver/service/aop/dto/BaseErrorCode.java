package com.zanghongtu.imserver.service.aop.dto;

public enum BaseErrorCode {
    /**
     * 成功
     */
    SUCCESS(0, "SUCCESS"),

    UNKNOWN(500, "未知异常，请联系管理员"),
    /**
     * 业务失败异常
     */
    FAILED(500, "Business Error, Please contact Admin"),

    /**
     * 未登录
     */
    USER_NO_LOGIN(500, "User is not login"),

    /**
     * 用户名密码不正确
     */
    LOGIN_FAILED(500, "User is not exsist or password doesn't match"),

    /**
     * 未知异常
     */
    ERROR(500, "系统错误，请联系管理员"),

    /**
     * Token失效
     */
    TOKEN_EXPIRED(500, "Token Expired"),

    /**
     * 刷新Token失败
     */
    REFRESH_TOKEN_EXPIRED(500, "refresh token expired"),

    /**
     * 用户无权限
     */
    USER_NOT_PERMITTED(500, "User do not have this permit"),

    /**
     * 参数检查异常
     */
    CHECK_ERROR(500, "Input params check failed"),

    /**
     * 验证码校验失败
     */
    CAPTCHA_CHECK_ERROR(500, "验证码校验失败"),

    CAPTCHA_TIMEOUT_ERROR(500, "验证码过期"),

    INVITE_CODE_NOT_EXIST(500, "邀请码不存在或已过期"),

    ALREADY_EXSISTS(500, "资源已存在"),

    RESOURCE_NOT_FOUND(500, "资源查询失败"),

    FILE_TYPE_ERROR(500, "文件类型错误");

    private final Integer code;

    private final String message;

    BaseErrorCode(Integer code, String message) {
        this.code = code;
        this.message = message;
    }

    public Integer getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}
