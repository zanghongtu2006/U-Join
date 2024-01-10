package com.zanghongtu.imserver.service;

import com.zanghongtu.imserver.controller.dto.login.TokenDTO;
import com.zanghongtu.imserver.model.User;

import java.util.Date;
import java.util.Map;

public interface ITokenService {
    TokenDTO generateToken(User user, String sessionId);

    String generateAccessToken(User user, String sessionId);

    String generateRefreshToken(User user, String sessionId);

    String generateRefreshToken(User user, String sessionId, Date issuedAt, Date expiration);

    Map<String, String> parseAccessToken(String token);

    Map<String, String> parseRefreshToken(String token);
}
