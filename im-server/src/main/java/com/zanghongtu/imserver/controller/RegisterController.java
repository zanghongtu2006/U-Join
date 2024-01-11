package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.chat.UserDTO;
import com.zanghongtu.imserver.exception.AlreadyExistsException;
import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.service.IUserService;
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
    @Autowired
    private IUserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/register")
    public UserDTO registerUser(@RequestBody UserDTO userDto) {
        if (userService.existsByUsername(userDto.getUsername())) {
            throw new AlreadyExistsException();
        }
        User newUser = new User();
        newUser.setUsername(userDto.getUsername());
        newUser.setPassword(passwordEncoder.encode(userDto.getPassword()));
        // 保存用户
        userService.save(newUser);
        return model2dto(newUser, UserDTO.class);
    }
}
