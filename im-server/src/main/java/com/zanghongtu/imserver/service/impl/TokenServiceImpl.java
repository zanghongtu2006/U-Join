package com.zanghongtu.imserver.service.impl;

import com.alibaba.fastjson.JSON;
import com.zanghongtu.imserver.config.TokenConfig;
import com.zanghongtu.imserver.controller.dto.login.TokenDTO;
import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.service.IRedisService;
import com.zanghongtu.imserver.service.ITokenService;
import com.zanghongtu.imserver.util.JwtUtil;
import com.zanghongtu.imserver.util.RedisKeyUtils;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.TimeUnit;

@Service
public class TokenServiceImpl implements ITokenService {
    @Autowired
    private IRedisService redisService;
    @Autowired
    private TokenConfig tokenConfig;

    @Override
    public TokenDTO generateToken(User user, String sessionId) {
        Date issuedAt = new Date();
        Date accessExpiration = new Date(issuedAt.getTime() + tokenConfig.getAccessTokenExpireTime());
        Date refreshExpiration = new Date(issuedAt.getTime() + tokenConfig.getRefreshTokenExpireTime() * 86400 * 24);
        String accessToken = generateAccessToken(user, sessionId, issuedAt, accessExpiration);
        String refreshToken = generateRefreshToken(user, sessionId, issuedAt, refreshExpiration);
        TokenDTO tokenDTO = new TokenDTO();
        tokenDTO.setRefresh_token(refreshToken);
        tokenDTO.setAccess_token(accessToken);
        tokenDTO.setToken_type("Bearer");
        tokenDTO.setSession_state(sessionId);
        tokenDTO.setScope("email profile");
        return tokenDTO;
    }


    @Override
    public String generateAccessToken(User user, String sessionId) {
        Date issuedAt = new Date();
        Date expiration = new Date(issuedAt.getTime() + tokenConfig.getAccessTokenExpireTime());
        return generateAccessToken(user, sessionId, issuedAt, expiration);
    }

    private String generateAccessToken(User user, String sessionId, Date issuedAt, Date expiration) {
        Map<String, Object> headers = new HashMap<>();
        headers.put("typ", "JWT");
        headers.put("kid", UUID.randomUUID().toString());
        Set<String> allowdOrigins = new HashSet<>();
        allowdOrigins.add("*");
        return Jwts.builder()
                .setHeader(headers)
                .setExpiration(expiration)
                .setIssuedAt(issuedAt)
                .setIssuer(tokenConfig.getAuthServerUrl() + "realms/" + tokenConfig.getRealm())
                .setAudience("vue")
                .setSubject(user.getId())
                .claim(TokenConfig.CLAIM_TYPE, "Bearer")
                .claim(TokenConfig.CLAIM_AZP, tokenConfig.getResource())
                .claim(TokenConfig.CLAIM_JTI, UUID.randomUUID().toString())
                .claim(TokenConfig.CLAIM_SESSION_STATE, sessionId)
                .claim(TokenConfig.CLAIM_SCOPE, "email profile")
                .claim(TokenConfig.CLAIM_EMAIL_VERIFIED, false)
                .claim(TokenConfig.CLAIM_PREFERRED_USER_NAME, user.getName())
                .claim(TokenConfig.CLAIM_ALLOWD_ORIGINS, allowdOrigins)
                .signWith(SignatureAlgorithm.HS256, tokenConfig.getAppSecret()).compact();
    }


    @Override
    public String generateRefreshToken(User user, String sessionId) {
        Date issuedAt = new Date();
        Date expiration = new Date(issuedAt.getTime() + tokenConfig.getRefreshTokenExpireTime());
        return generateRefreshToken(user, sessionId, issuedAt, expiration);
    }


    @Override
    public String generateRefreshToken(User user, String sessionId, Date issuedAt, Date expiration) {
        Map<String, Object> headers = new HashMap<>();
        headers.put("typ", "JWT");
        headers.put("kid", UUID.randomUUID().toString());
        redisService.set(RedisKeyUtils.getSessionUserName(sessionId), JSON.toJSONString(user), tokenConfig.getRefreshTokenExpireTime(), TimeUnit.DAYS);
        return Jwts.builder()
                .setHeader(headers)
                .setExpiration(expiration)
                .setIssuedAt(issuedAt)
                .setIssuer(tokenConfig.getAuthServerUrl())
                .setAudience(tokenConfig.getAuthServerUrl())
                .setSubject(user.getId())
                .claim(TokenConfig.CLAIM_JTI, UUID.randomUUID().toString())
                .claim(TokenConfig.CLAIM_SESSION_STATE, sessionId)
                .claim(TokenConfig.CLAIM_SCOPE, "email profile")
                .claim(TokenConfig.CLAIM_TYPE, "Refresh")
                .claim(TokenConfig.CLAIM_AZP, tokenConfig.getResource())
                .signWith(SignatureAlgorithm.HS256, tokenConfig.getAppSecret()).compact();
    }

    @Override
    public Map<String, String> parseAccessToken(String token) {
        return JwtUtil.parse(token);
    }

    @Override
    public Map<String, String> parseRefreshToken(String token) {
        return JwtUtil.parse(token);
    }
}
