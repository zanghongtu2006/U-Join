package com.zanghongtu.imserver;

import com.zanghongtu.imserver.controller.LoginController;
import com.zanghongtu.imserver.controller.dto.login.TokenRequestDTO;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.messaging.converter.StringMessageConverter;
import org.springframework.messaging.simp.stomp.*;
import org.springframework.web.socket.WebSocketHttpHeaders;
import org.springframework.web.socket.client.standard.StandardWebSocketClient;
import org.springframework.web.socket.messaging.WebSocketStompClient;

import java.lang.reflect.Type;
import java.util.Optional;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest(classes = MessagingStompWebsocketApplication.class)
public class StompWebSocketTest {
    @Autowired
    private LoginController loginController;

    @Test
    public void testReceiveMessageFromImServer() throws Exception {
        CountDownLatch latch = new CountDownLatch(1);
        WebSocketStompClient stompClient = new WebSocketStompClient(new StandardWebSocketClient());
        stompClient.setMessageConverter(new StringMessageConverter());

        // 设置带有Authorization头的StompHeaders
        StompHeaders connectHeaders = new StompHeaders();
        TokenRequestDTO tokenRequestDTO = new TokenRequestDTO();
        tokenRequestDTO.setUsername("axingxing");
        tokenRequestDTO.setPassword("password");
        String token = loginController.login(tokenRequestDTO).getAccessToken();
        System.out.println(token);
        connectHeaders.add("Authorization", "Bearer " + token);  // 添加Authorization头
        WebSocketHttpHeaders webSocketHttpHeaders = new WebSocketHttpHeaders();
        webSocketHttpHeaders.add("Authorization", "Bearer " + token);

        String url = "ws://192.168.168.25:8081/chatserver/";
        StompSessionHandler stompSessionHandler = new CustomStompSessionHandler();
        StompSession stompSession = stompClient.connect(url, webSocketHttpHeaders, connectHeaders, stompSessionHandler).get();
//
//        session.subscribe("/user/topic/greetings", new StompFrameHandler() {
//            @Override
//            public Type getPayloadType(StompHeaders headers) {
//                return String.class;
//            }
//
//            @Override
//            public void handleFrame(StompHeaders headers, Object payload) {
//                String message = (String) payload;
//                assertEquals("Hello, Client!", message);
//                latch.countDown();
//            }
//        });

        // 发送测试消息
//        session.send("/app/hello", "Hello, Server!");

        // 等待消息接收，超时则测试失败
        latch.await(3, TimeUnit.DAYS);
    }

    private class CustomStompSessionHandler implements StompSessionHandler {
        @Override
        public void afterConnected(StompSession session, StompHeaders connectedHeaders) {
            System.out.println("Connected.");
        }

        @Override
        public void handleException(StompSession session, StompCommand command, StompHeaders headers, byte[] payload, Throwable exception) {
            exception.printStackTrace();
        }

        @Override
        public void handleTransportError(StompSession session, Throwable exception) {
            exception.printStackTrace();
        }

        @Override
        public Type getPayloadType(StompHeaders headers) {
            return null;
        }

        @Override
        public void handleFrame(StompHeaders headers, Object payload) {
            System.out.println(payload.toString());
        }
    }
}
