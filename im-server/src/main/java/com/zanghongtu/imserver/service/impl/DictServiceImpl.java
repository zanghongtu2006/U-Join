package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.Dict;
import com.zanghongtu.imserver.repository.DictRepository;
import com.zanghongtu.imserver.service.IDictService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Slf4j
@Service
public class DictServiceImpl extends BaseServiceImpl<Dict, String> implements IDictService {
    @Autowired
    private DictRepository repository;

    public DictServiceImpl(JpaRepositoryImplementation<Dict, String> repository) {
        super(repository);
    }

    @Override
    public Optional<Dict> getByCode(String code) {
        Dict example = new Dict();
        example.setCode(code);
        return findOne(Example.of(example));
    }

}
