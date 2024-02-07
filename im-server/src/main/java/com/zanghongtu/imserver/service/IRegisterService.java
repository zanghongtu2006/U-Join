package com.zanghongtu.imserver.service;

import com.zanghongtu.imserver.model.User;
import com.zanghongtu.imserver.model.UserInfo;

public interface IRegisterService {
    UserInfo register(String userName, User newUser);
}
