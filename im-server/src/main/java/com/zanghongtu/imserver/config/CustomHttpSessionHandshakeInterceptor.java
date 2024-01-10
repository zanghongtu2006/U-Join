package com.zanghongtu.imserver.config;

import com.zanghongtu.imserver.service.ITokenService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.List;
import java.util.Map;

@Slf4j
@Component
public class CustomHttpSessionHandshakeInterceptor implements HandshakeInterceptor {
    @Autowired
    private ITokenService tokenService;

    @Override
    public boolean beforeHandshake(@NonNull ServerHttpRequest request, @NonNull ServerHttpResponse response,
                                   @NonNull WebSocketHandler wsHandler, @NonNull Map<String, Object> attributes) {
        if (request instanceof ServletServerHttpRequest servletRequest) {
            List<String> authorizations = servletRequest.getHeaders().get("Authorization");
            if (CollectionUtils.isEmpty(authorizations)) {
                response.setStatusCode(HttpStatusCode.valueOf(401));
                return false;
            }
            String token = authorizations.get(0).replaceFirst("Bearer", "").replaceFirst("bearer", "");
            Map<String, String> map = tokenService.parseAccessToken(token);
            if (CollectionUtils.isEmpty(map) || !map.containsKey(Constants.USER_ID)) {
                return false;
            }
            attributes.putAll(map);
            return true;
        }
        return false;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Exception exception) {
        log.info("After Handshake");
    }
}
