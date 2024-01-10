package com.zanghongtu.imserver.config;

import org.springframework.context.ApplicationListener;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.GenericMessage;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;

import java.util.Map;
import java.util.Objects;

@Component
public class StompConnectedEventListener implements ApplicationListener<SessionConnectedEvent> {
    @Override
    public void onApplicationEvent(SessionConnectedEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = headerAccessor.getSessionId();
        MessageHeaderAccessor messageHeaderAccessor = new MessageHeaderAccessor(event.getMessage());
        GenericMessage genericMessage = (GenericMessage) messageHeaderAccessor.getHeader("simpConnectMessage");
        MessageHeaders messageHeaders = genericMessage.getHeaders();
        Map<String, Object> attibutes = (Map<String, Object>) messageHeaders.get("simpSessionAttributes");
        String userId = attibutes.get(Constants.USER_ID).toString();
        // 使用sessionId
        Constants.USER_SESSION_MAP.put(userId, sessionId);
    }

    @Override
    public boolean supportsAsyncExecution() {
        return ApplicationListener.super.supportsAsyncExecution();
    }
}
