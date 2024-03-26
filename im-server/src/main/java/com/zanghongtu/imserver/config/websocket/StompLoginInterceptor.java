package com.zanghongtu.imserver.config.websocket;

import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageBuilder;
import org.springframework.messaging.support.MessageHeaderAccessor;

import java.nio.charset.StandardCharsets;
import java.security.Principal;

public class StompLoginInterceptor implements ChannelInterceptor {
    /**
     * Invoked before the Message is actually sent to the channel.
     * This allows for modification of the Message if necessary.
     * If this method returns {@code null} then the actual
     * send invocation will not occur.
     */
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        // 从Header中可以读取login和passcode
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
        if (StompCommand.CONNECT.equals(accessor.getCommand())) {
            boolean invalidToken = false;
            if (accessor.getSessionAttributes().containsKey("invalidToken")) {
                invalidToken = ( boolean) accessor.getSessionAttributes().get("invalidToken");
            }
            if (invalidToken) {
                StompHeaderAccessor errorAccessor = StompHeaderAccessor.create(StompCommand.ERROR);
                errorAccessor.setSessionId(accessor.getSessionId());
                errorAccessor.setReceiptId(accessor.getReceiptId());
                errorAccessor.addNativeHeader("message", "Invalid or expired token");
                byte[] payload = "Invalid or expired token".getBytes(StandardCharsets.UTF_8);
                return MessageBuilder.createMessage(payload, errorAccessor.getMessageHeaders());
            }
            Principal user = new Principal() {
                @Override
                public String getName() {
                    // 这里可以做登录验证逻辑，除了getLogin()可以getPasscode()拿到密码做登录验证。
                    return accessor.getSessionId();
                }
            };
            // 设置用户
            accessor.setUser(user);
        }
        return message;
    }
}
