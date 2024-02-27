//package com.zanghongtu.imserver.config;
//
//import com.zanghongtu.imserver.mq.WebSocketSessionHandler;
//import com.zanghongtu.imserver.service.IConversationUserService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.ApplicationListener;
//import org.springframework.messaging.MessageHeaders;
//import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
//import org.springframework.messaging.support.GenericMessage;
//import org.springframework.messaging.support.MessageHeaderAccessor;
//import org.springframework.stereotype.Component;
//import org.springframework.web.socket.messaging.SessionConnectedEvent;
//
//import java.util.Map;
//
//@Component
//public class StompConnectedEventListener implements ApplicationListener<SessionConnectedEvent> {
//    @Autowired
//    private WebSocketSessionHandler webSocketSessionHandler;
//
//    @Autowired
//    private IConversationUserService conversationUserService;
//
//    @Override
//    public void onApplicationEvent(SessionConnectedEvent event) {
//        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
//        String sessionId = headerAccessor.getSessionId();
//        MessageHeaderAccessor messageHeaderAccessor = new MessageHeaderAccessor(event.getMessage());
//        GenericMessage genericMessage = (GenericMessage) messageHeaderAccessor.getHeader("simpConnectMessage");
//        MessageHeaders messageHeaders = genericMessage.getHeaders();
//        Map<String, Object> attibutes = (Map<String, Object>) messageHeaders.get("simpSessionAttributes");
//        String userId = attibutes.get(Constants.USER_ID).toString();
//        // 使用sessionId
//        Constants.USER_SESSION_MAP.put(userId, sessionId);
//        // 创建监听
//        webSocketSessionHandler.onWebSocketConnected(userId);
//    }
//
//    @Override
//    public boolean supportsAsyncExecution() {
//        return ApplicationListener.super.supportsAsyncExecution();
//    }
//}
