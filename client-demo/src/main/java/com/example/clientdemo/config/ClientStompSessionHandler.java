package com.example.clientdemo.config;

import com.example.clientdemo.controller.dto.HelloMessage;
import com.example.clientdemo.controller.dto.chat.ChatDTO;
import com.example.clientdemo.service.IChatMessageService;
import com.example.clientdemo.service.StompSessionService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.lang.NonNull;
import org.springframework.messaging.simp.stomp.*;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.web.socket.WebSocketHttpHeaders;
import org.springframework.web.socket.messaging.WebSocketStompClient;

import java.lang.reflect.Type;
import java.util.Date;

@Slf4j
public class ClientStompSessionHandler extends StompSessionHandlerAdapter {
    @Autowired
    private StompSessionService stompSessionService;
    @Autowired
    private IChatMessageService chatMessageService;

    private final WebSocketStompClient stompClient;
    private final TaskScheduler taskScheduler;

    private final Config config;

    public ClientStompSessionHandler(WebSocketStompClient stompClient, TaskScheduler taskScheduler, Config config) {
        this.stompClient = stompClient;
        this.taskScheduler = taskScheduler;
        this.config = config;
        reconnect();
    }

    @Override
    public void afterConnected(StompSession session, @NonNull StompHeaders headers) {
        log.info("{}, {}", session.getSessionId(), session.isConnected());
        stompSessionService.setStompSession(session);
        log.info("Client connected: headers {}", headers);

        String message = "one-time message from client";
        log.info("Client sends: {}", message);
        session.send("/app/hello", new HelloMessage(message));
        session.subscribe("/user/topic/greetings", new StompFrameHandler() {
            @Override
            public Type getPayloadType(StompHeaders headers) {
                return HelloMessage.class; // 替换成你期望的消息类型
            }

            @Override
            public void handleFrame(StompHeaders headers, Object payload) {
                HelloMessage message = (HelloMessage) payload;
                log.info("Recv {}", message);
            }
        });

        // 订阅指定主题
        session.subscribe("/topic/chat-reply", new StompFrameHandler() {
            @Override
            public Type getPayloadType(StompHeaders headers) {
                return ChatDTO.class; // 替换成你期望的消息类型
            }

            @Override
            public void handleFrame(StompHeaders headers, Object payload) {
                ChatDTO message = (ChatDTO) payload;
                chatMessageService.dealChatReplyMessage(message);
            }
        });
    }

    @Override
    public void handleFrame(@NonNull StompHeaders headers, Object payload) {
        log.info("Client received: payload {}, headers {}", payload, headers);
    }

    @Override
    public void handleException(@NonNull StompSession session, StompCommand command,
                                @NonNull StompHeaders headers, @NonNull byte[] payload, Throwable exception) {
        log.error("Client error: exception {}, command {}, payload {}, headers {}",
                exception.getMessage(), command, payload, headers);
    }

    @Override
    public void handleTransportError(StompSession session, Throwable exception) {
        log.error("Client transport error: error {}", exception.getMessage());
        if (!session.isConnected()) {
            // 如果连接断开，启动一个重连任务
            taskScheduler.schedule(this::reconnect, new Date(System.currentTimeMillis() + 30000).toInstant());  // 10秒后尝试重连
        }
    }

    private void reconnect() {
        String token = "eyJraWQiOiI1ZWMzNjEzZS1iNWVhLTQ2OWYtOGQ3YS1iMGE3YzdkMzA2MjMiLCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MDQ4NjQ2NDAsImlhdCI6MTcwNDc3ODI0MCwiaXNzIjoiaHR0cHM6Ly9zc28uemFuZ2hvbmd0dS5jb20vcmVhbG1zL2FpIiwiYXVkIjoidnVlIiwic3ViIjoiODIyMzE4ODgtOWU0My00MzY5LTg3NjUtYzMzZmE1MWQxNzQxIiwidHlwIjoiQmVhcmVyIiwianRpIjoiN2M2N2NiZWQtMzM5YS00MTYxLTkzOTEtNTFjMjJjOGM1NzdhIiwic2Vzc2lvbl9zdGF0ZSI6ImRjNGNkNzE5LWZhNTItNDVjNS04NzVkLTE3NWI1MDE4YjFiNiIsInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwicHJlZmVycmVkX3VzZXJuYW1lIjoiemhhbmdzYW4iLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdfQ.GgKsvFqrMb_JnZP6IyEwK3hQSxPLwsig0ficUtR9X5w";
        StompHeaders stompHeaders = new StompHeaders();
        stompHeaders.setLogin("foo"); // 设置用户名
        stompHeaders.setPasscode("bar"); // 设置密码
        WebSocketHttpHeaders headers = new WebSocketHttpHeaders();
        headers.setBearerAuth(token);
        // 重连逻辑
        stompClient.connectAsync(config.getUrl(), headers, stompHeaders, this);
    }
}
