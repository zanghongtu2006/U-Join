package com.zanghongtu.imserver.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic");
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/chatserver").setAllowedOrigins("*")
                .withSockJS().setInterceptors(customHttpSessionHandshakeInterceptor());
    }

    @Bean
    public CustomHttpSessionHandshakeInterceptor customHttpSessionHandshakeInterceptor() {
        return new CustomHttpSessionHandshakeInterceptor();
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        // 配置登录拦截器
        registration.interceptors(new StompLoginInterceptor());
    }
}
