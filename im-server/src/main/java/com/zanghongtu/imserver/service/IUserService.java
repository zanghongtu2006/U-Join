package com.zanghongtu.imserver.service;


import com.zanghongtu.imserver.model.User;

import java.util.Optional;

public interface IUserService extends IBaseService<User, String> {
    User login(String name, String password);

    boolean existsByUsername(String username);

    Optional<User> findByUsername(String username);
}
