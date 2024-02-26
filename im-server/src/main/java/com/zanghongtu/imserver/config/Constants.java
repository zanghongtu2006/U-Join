package com.zanghongtu.imserver.config;

import org.springframework.web.socket.messaging.SessionConnectedEvent;

import java.util.HashMap;
import java.util.Map;

public class Constants {
    public static final String USER_ID = "user-id";

    public static final String USER_NAME = "user-name";
    public static final String SESSION_ID = "session-id";

    public static final Map<String, String> USER_SESSION_MAP = new HashMap<>();
    public static final Map<String, SessionConnectedEvent> USER_SESSIONEVENT_MAP = new HashMap<>();
}
