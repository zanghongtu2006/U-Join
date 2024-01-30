package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.login.TokenDTO;
import com.zanghongtu.imserver.controller.dto.login.TokenResultDTO;
import com.zanghongtu.imserver.controller.dto.user.UserRegisterDTO;
import com.zanghongtu.imserver.controller.dto.user.UserStatus;
import com.zanghongtu.imserver.exception.AlreadyExistsException;
import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.model.UserInfo;
import com.zanghongtu.imserver.service.ITokenService;
import com.zanghongtu.imserver.service.IUserInfoService;
import com.zanghongtu.imserver.service.IUserService;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("register")
public class RegisterController extends BaseController {

    private final IUserService userService;

    private final IUserInfoService userInfoService;

    private final PasswordEncoder passwordEncoder;

    private final ITokenService tokenService;

    @Autowired
    public RegisterController(IUserService userService,
                              IUserInfoService userInfoService,
                              PasswordEncoder passwordEncoder,
                              ITokenService tokenService) {
        this.userService = userService;
        this.userInfoService = userInfoService;
        this.passwordEncoder = passwordEncoder;
        this.tokenService = tokenService;
    }

    @PostMapping("")
    @Transactional(rollbackOn = Exception.class)
    public TokenResultDTO registerUser(@RequestBody UserRegisterDTO userDto) {
        if (userService.existsByUsername(userDto.getUsername())) {
            throw new AlreadyExistsException("该用户已存在");
        }
        User newUser = new User();
        newUser.setUsername(userDto.getUsername());
        newUser.setPassword(passwordEncoder.encode(userDto.getPassword()));
        // 保存用户
        userService.save(newUser);
        UserInfo userInfo = new UserInfo();
        userInfo.setAuthUserId(newUser.getId());
        userInfo.setFullName(userDto.getUsername());
        userInfo.setStatus(UserStatus.REGISTERD);
        userInfoService.insert(userInfo);

        String sessionID = UUID.randomUUID().toString();
        TokenDTO tokenDTO = tokenService.generateToken(userInfo, sessionID);
        TokenResultDTO loginResultDTO = new TokenResultDTO();
        loginResultDTO.setUserId(userInfo.getId());
        loginResultDTO.setAccessToken(tokenDTO.getAccess_token());
        loginResultDTO.setRefreshToken(tokenDTO.getRefresh_token());

        return loginResultDTO;
    }
}
