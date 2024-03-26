package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.Image;
import com.zanghongtu.imserver.repository.ImageRepository;
import com.zanghongtu.imserver.service.IImageService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class ImageServiceImpl extends BaseServiceImpl<Image, String> implements IImageService {
    @Autowired
    private ImageRepository repository;

    public ImageServiceImpl(JpaRepositoryImplementation<Image, String> repository) {
        super(repository);
    }

}
