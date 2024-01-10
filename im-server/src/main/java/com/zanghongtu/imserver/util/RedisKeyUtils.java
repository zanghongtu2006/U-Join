package com.zanghongtu.imserver.util;

import java.util.Objects;

public class RedisKeyUtils {

    private static final String SESSION_USERNAME = "sessionid:%s";

    
    public static String getSessionUserName(String sessionId) {
        Objects.requireNonNull(sessionId);
        return String.format(SESSION_USERNAME, sessionId);
    }
}
