package com.zanghongtu.imserver;

import com.zanghongtu.imserver.controller.LoginController;
import com.zanghongtu.imserver.controller.dto.login.TokenRequestDTO;
import com.zanghongtu.imserver.controller.dto.login.TokenResultDTO;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@Slf4j
@SpringBootTest(classes = MessagingStompWebsocketApplication.class)
public class TestController {
    @Autowired
    private LoginController loginController;

    @Test
    public void testLogin() {
        TokenRequestDTO tokenRequestDTO = new TokenRequestDTO();
        tokenRequestDTO.setUsername("axingxing");
        tokenRequestDTO.setPassword("password");
        TokenResultDTO tokenResultDTO = loginController.login(tokenRequestDTO);
        log.info("AccessToken: {}", tokenResultDTO.getAccessToken());
        log.info("UserID: {}", tokenResultDTO.getUserId());
    }
}
