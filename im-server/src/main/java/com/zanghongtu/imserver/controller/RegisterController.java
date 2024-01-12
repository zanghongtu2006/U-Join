package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.chat.UserDTO;
import com.zanghongtu.imserver.controller.dto.user.UserInfoDTO;
import com.zanghongtu.imserver.controller.dto.user.UserRegisterDTO;
import com.zanghongtu.imserver.exception.AlreadyExistsException;
import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.model.UserInfo;
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

@Slf4j
@RestController
@RequestMapping("register")
public class RegisterController extends BaseController {

    private final IUserService userService;

    private final IUserInfoService userInfoService;

    private final PasswordEncoder passwordEncoder;

    @Autowired
    public RegisterController(IUserService userService,
                              IUserInfoService userInfoService,
                              PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.userInfoService = userInfoService;
        this.passwordEncoder = passwordEncoder;
    }

    @PostMapping("")
    @Transactional(rollbackOn = Exception.class)
    public UserInfoDTO registerUser(@RequestBody UserRegisterDTO userDto) {
        if (userService.existsByUsername(userDto.getUsername())) {
            throw new AlreadyExistsException();
        }
        User newUser = new User();
        newUser.setUsername(userDto.getUsername());
        newUser.setPassword(passwordEncoder.encode(userDto.getPassword()));
        // 保存用户
        userService.save(newUser);
        UserInfo userInfo = new UserInfo();
        userInfo.setAuthUserId(newUser.getId());
        userInfoService.insert(userInfo);
        return model2dto(userInfo, UserInfoDTO.class);
    }
}
