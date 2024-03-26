package com.zanghongtu.imserver.config.websocket;

import com.zanghongtu.imserver.config.Constants;
import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.service.ITokenService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.security.Principal;
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
            if (!CollectionUtils.isEmpty(authorizations)) {
                String token = authorizations.get(0).replaceFirst("Bearer", "").replaceFirst("bearer", "");
                Map<String, String> map = tokenService.parseAccessToken(token);
                if (map.containsKey(Constants.USER_ID)) {
                    User user = new User();
                    user.setId(map.get(Constants.USER_ID));
                    attributes.putAll(map);
                    attributes.put("user", user);
                    attributes.put("userId", user.getId());
                    log.info(attributes.keySet().toString());

                    Principal userPrincipal = () -> {
                        return map.get(Constants.USER_ID); // 从令牌解析得到的用户ID
                    };
                    // 将Principal设置到WebSocket会话中
                    attributes.put("principal", userPrincipal);
                    return true;
                }
            }
        }
        attributes.put("invalidToken", true);
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Exception exception) {
        log.info("After Handshake");
    }
}
