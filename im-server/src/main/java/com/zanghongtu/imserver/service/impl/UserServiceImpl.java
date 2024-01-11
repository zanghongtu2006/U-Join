package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.repository.UserRepository;
import com.zanghongtu.imserver.service.IUserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Slf4j
@Service
public class UserServiceImpl extends BaseServiceImpl<User, String> implements IUserService {
    @Autowired
    private UserRepository repository;

    public UserServiceImpl(JpaRepositoryImplementation<User, String> repository) {
        super(repository);
    }

    @Override
    public User login(String name, String password) {
        return null;
    }

    @Override
    public boolean existsByUsername(String username) {
        User user = new User();
        user.setUsername(username);
        return exists(Example.of(user));
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return repository.findByUsername(username);
    }
}
