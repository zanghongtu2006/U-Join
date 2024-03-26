package com.zanghongtu.imserver.repository;

import com.zanghongtu.imserver.model.Image;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;

public interface ImageRepository extends JpaRepositoryImplementation<Image, String> {

}