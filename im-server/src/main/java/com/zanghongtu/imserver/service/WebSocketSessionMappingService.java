package com.zanghongtu.imserver.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
public class WebSocketSessionMappingService {
    private final ConcurrentHashMap<String, String> sessionUserMap = new ConcurrentHashMap<>();

    private final ConcurrentHashMap<String, String> userSessionMap = new ConcurrentHashMap<>();

    public void registerSession(String userId, String sessionId) {
        sessionUserMap.put(sessionId, userId);
        userSessionMap.put(userId, sessionId);
    }

    public void removeSession(String sessionId) {
        sessionUserMap.remove(sessionId);
    }
    public void removeUser(String userId) {
        userSessionMap.remove(userId);
    }

    public String getUserId(String sessionId) {
        return sessionUserMap.get(sessionId);
    }

    public String getSessionId(String userId) {
        return userSessionMap.get(userId);
    }
}
