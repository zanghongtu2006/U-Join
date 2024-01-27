package com.zanghongtu.imserver.service;


import com.zanghongtu.imserver.model.UserInfo;

import java.util.Optional;

public interface IUserInfoService extends IBaseService<UserInfo, String> {
    Optional<UserInfo> getByAuthId(String id);
}
