package com.zanghongtu.imserver.service;


import com.zanghongtu.imserver.model.UserTag;

public interface IUserTagService extends IBaseService<UserTag, String> {
    void deleteByUIdAndCode(String userId, String code);
}
