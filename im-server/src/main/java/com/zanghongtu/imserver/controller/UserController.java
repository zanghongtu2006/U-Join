package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("users")
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @GetMapping(path = "")
    public List<User> list() {
        log.info("in user list");
        return userRepository.findAll();
    }
}
