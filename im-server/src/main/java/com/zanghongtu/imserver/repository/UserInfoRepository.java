package com.zanghongtu.imserver.repository;

import com.zanghongtu.imserver.model.UserInfo;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;

public interface UserInfoRepository extends JpaRepositoryImplementation<UserInfo, String> {

}