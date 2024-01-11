package com.zanghongtu.imserver.repository;

import com.zanghongtu.imserver.model.User;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;

import java.util.Optional;

public interface UserRepository extends JpaRepositoryImplementation<User, String> {
    Optional<User> findByUsername(String username);

}