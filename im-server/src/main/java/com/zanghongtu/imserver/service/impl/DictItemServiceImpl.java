package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.Dict;
import com.zanghongtu.imserver.model.DictItem;
import com.zanghongtu.imserver.repository.DictItemRepository;
import com.zanghongtu.imserver.repository.UserInfoRepository;
import com.zanghongtu.imserver.service.IDictItemService;
import com.zanghongtu.imserver.service.IDictService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class DictItemServiceImpl extends BaseServiceImpl<DictItem, String> implements IDictItemService {
    @Autowired
    private DictItemRepository repository;

    public DictItemServiceImpl(JpaRepositoryImplementation<DictItem, String> repository) {
        super(repository);
    }
}
