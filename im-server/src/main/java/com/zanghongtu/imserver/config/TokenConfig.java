package com.zanghongtu.imserver.config;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@Data
@ConfigurationProperties(prefix = "sso")
public class TokenConfig {
    private String realm = "ai";

    private String resource;

    @JsonProperty("auth-server-url")
    private String authServerUrl = "https://sso.zanghongtu.com/";

    private String subject = "HONGTU";
    private String appSecret = "HONGTU";
    private long accessTokenExpireTime = 86400000/24/12; //1天
    private long refreshTokenExpireTime = 30;

    public static final String CLAIM_TYPE = "typ";
    public static final String CLAIM_AZP = "azp";
    public static final String CLAIM_JTI = "jti";
    public static final String CLAIM_SESSION_STATE = "session_state";
    public static final String CLAIM_SCOPE = "scope";
    public static final String CLAIM_EMAIL_VERIFIED = "email_verified";
    public static final String CLAIM_PREFERRED_USER_NAME = "preferred_username";
    public static final String CLAIM_ALLOWD_ORIGINS = "allowed-origins";
}
