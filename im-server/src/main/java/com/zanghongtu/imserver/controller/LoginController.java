package com.zanghongtu.imserver.controller;

import com.alibaba.fastjson2.JSON;
import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.zanghongtu.imserver.config.TokenConfig;
import com.zanghongtu.imserver.controller.dto.login.TokenDTO;
import com.zanghongtu.imserver.controller.dto.login.TokenRequestDTO;
import com.zanghongtu.imserver.controller.dto.login.TokenResultDTO;
import com.zanghongtu.imserver.exception.BaseException;
import com.zanghongtu.imserver.exception.CheckException;
import com.zanghongtu.imserver.exception.login.LoginFailedException;
import com.zanghongtu.imserver.exception.login.RefreshTokenExpiredException;
import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.service.IRedisService;
import com.zanghongtu.imserver.service.ITokenService;
import com.zanghongtu.imserver.service.IUserService;
import com.zanghongtu.imserver.util.RedisKeyUtils;
import io.micrometer.common.util.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("token")
public class LoginController {
    private final ITokenService tokenService;

    private final IRedisService redisService;

    private final IUserService userService;


    private final PasswordEncoder passwordEncoder;

    @Autowired
    public LoginController(ITokenService tokenService,
                           IRedisService redisService,
                           IUserService userService,
                           PasswordEncoder passwordEncoder) {
        this.tokenService = tokenService;
        this.redisService = redisService;
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @PostMapping(path = "login")
    public TokenResultDTO login(@RequestBody TokenRequestDTO tokenRequestDTO) {
        if (StringUtils.isEmpty(tokenRequestDTO.getUsername()) || StringUtils.isEmpty(tokenRequestDTO.getPassword())) {
            throw new CheckException();
        }
        User user = userService.findByUsername(tokenRequestDTO.getUsername())
                .orElseThrow(LoginFailedException::new);
        if (!passwordEncoder.matches(tokenRequestDTO.getPassword(), user.getPassword())) {
            throw new LoginFailedException();
        }
        String sessionID = UUID.randomUUID().toString();
        TokenDTO tokenDTO = tokenService.generateToken(user, sessionID);
        TokenResultDTO loginResultDTO = new TokenResultDTO();
        loginResultDTO.setUsername(user.getUsername());
        loginResultDTO.setUserId(user.getId());
        loginResultDTO.setAccessToken(tokenDTO.getAccess_token());
        loginResultDTO.setRefreshToken(tokenDTO.getRefresh_token());
        return loginResultDTO;
    }

    @PostMapping(path = "refresh")
    public TokenResultDTO refresh(@RequestBody TokenRequestDTO tokenRequestDTO) throws BaseException {
        String refreshToken = tokenRequestDTO.getRefreshToken();
        DecodedJWT jwt = JWT.decode(refreshToken);
        if (!jwt.getClaim("typ").asString().equalsIgnoreCase("refresh") || jwt.getExpiresAt().before(new Date())) {
            throw new RefreshTokenExpiredException();
        }
        String sessionId = jwt.getClaim(TokenConfig.CLAIM_SESSION_STATE).asString();
        User user = JSON.parseObject(redisService.get(RedisKeyUtils.getSessionUserName(sessionId)).toString(), User.class);
        TokenDTO tokenDTO = tokenService.generateToken(user, sessionId);
        TokenResultDTO loginResultDTO = new TokenResultDTO();
        loginResultDTO.setUsername(user.getUsername());
        loginResultDTO.setUserId(user.getId());
        loginResultDTO.setAccessToken(tokenDTO.getAccess_token());
        loginResultDTO.setRefreshToken(tokenDTO.getRefresh_token());
        return loginResultDTO;
    }
}
