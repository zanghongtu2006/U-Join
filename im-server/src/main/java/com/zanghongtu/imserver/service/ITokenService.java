package com.zanghongtu.imserver.service;

import com.zanghongtu.imserver.controller.dto.login.TokenDTO;
import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.model.UserInfo;

import java.util.Date;
import java.util.Map;

public interface ITokenService {
    TokenDTO generateToken(UserInfo user, String sessionId);

    String generateAccessToken(UserInfo user, String sessionId);

    String generateRefreshToken(UserInfo user, String sessionId);

    String generateRefreshToken(UserInfo user, String sessionId, Date issuedAt, Date expiration);

    Map<String, String> parseAccessToken(String token);

    Map<String, String> parseRefreshToken(String token);
}
