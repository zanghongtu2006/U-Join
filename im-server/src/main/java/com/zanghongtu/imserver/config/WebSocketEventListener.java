package com.zanghongtu.imserver.config;

import com.zanghongtu.imserver.service.WebSocketSessionMappingService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.GenericMessage;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import java.util.Map;

@Slf4j
@Component
public class WebSocketEventListener {

    @Autowired
    private WebSocketSessionMappingService mappingService;

    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        MessageHeaderAccessor messageHeaderAccessor = new MessageHeaderAccessor(event.getMessage());
        GenericMessage genericMessage = (GenericMessage) messageHeaderAccessor.getHeader("simpConnectMessage");
        MessageHeaders messageHeaders = genericMessage.getHeaders();
        Map<String, Object> attibutes = (Map<String, Object>) messageHeaders.get("simpSessionAttributes");
        String userId = attibutes.get(Constants.USER_ID).toString();
        String sessionId = headerAccessor.getSessionId(); // 获取WebSocket会话ID
        mappingService.registerSession(userId, sessionId);
        log.info("Received a new web socket connection from userId: " + userId);
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        // 从WebSocket会话中获取用户ID或其他标识符
        String userId = headerAccessor.getSessionAttributes().get("user-id").toString();
        // 调用方法停止并销毁该用户的消费者
        destroyConsumerForUser(userId);
        String sessionId = headerAccessor.getSessionId();
        mappingService.removeSession(sessionId);
        mappingService.removeUser(userId);
        log.info("User web socket connection closed: " + sessionId);
    }

    private void destroyConsumerForUser(String userId) {
        System.out.println(userId + userId + userId);
        // 实现停止并销毁特定用户的RocketMQ消费者的逻辑
        // 这里的实现将依赖于您如何管理和引用这些消费者实例
    }
}
