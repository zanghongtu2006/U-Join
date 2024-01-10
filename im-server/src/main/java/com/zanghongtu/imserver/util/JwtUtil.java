package com.zanghongtu.imserver.util;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.zanghongtu.imserver.config.Constants;
import com.zanghongtu.imserver.config.TokenConfig;
import lombok.extern.slf4j.Slf4j;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Slf4j
public class JwtUtil {

    public static Map<String, String> parse(String token) {
        DecodedJWT jwt = JWT.decode(token);
        if (jwt.getExpiresAt().before(new Date())) {
            log.error("token 超时");
            return new HashMap<>();
        }

        Map<String, String> result = new HashMap<>(3);
        result.put(Constants.USER_ID, jwt.getSubject());
        result.put(Constants.SESSION_ID, jwt.getClaim(TokenConfig.CLAIM_SESSION_STATE).asString());
        return result;
    }
}
