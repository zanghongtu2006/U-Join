package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.UserInfo;
import com.zanghongtu.imserver.repository.UserInfoRepository;
import com.zanghongtu.imserver.service.IUserInfoService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class UserInfoServiceImpl extends BaseServiceImpl<UserInfo, String> implements IUserInfoService {
    @Autowired
    private UserInfoRepository repository;

    public UserInfoServiceImpl(JpaRepositoryImplementation<UserInfo, String> repository) {
        super(repository);
    }

}
