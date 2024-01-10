package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));
    }

    public UserDetails getById(String userId) {
        User example = new User();
        example.setId(userId);
        return userRepository.findOne(Example.of(example))
                .orElseThrow(() -> new UsernameNotFoundException("User not found with userId: " + userId));
    }
}
