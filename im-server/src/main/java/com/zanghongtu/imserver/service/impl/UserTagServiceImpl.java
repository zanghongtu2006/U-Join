package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.UserTag;
import com.zanghongtu.imserver.repository.UserTagRepository;
import com.zanghongtu.imserver.service.IUserTagService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Slf4j
@Service
public class UserTagServiceImpl extends BaseServiceImpl<UserTag, String> implements IUserTagService {
    @Autowired
    private UserTagRepository repository;

    public UserTagServiceImpl(JpaRepositoryImplementation<UserTag, String> repository) {
        super(repository);
    }

    @Override
    public void deleteByUIdAndCode(String userId, String code) {
        UserTag userTag = new UserTag();
        userTag.setTagCode(code);
        userTag.setUserId(userId);
        List<UserTag> userTags = findAll(Example.of(userTag));
        if (CollectionUtils.isEmpty(userTags)) {
            return;
        }
        repository.deleteAllInBatch(userTags);
    }
}
