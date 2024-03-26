package com.zanghongtu.imserver.repository;

import com.zanghongtu.imserver.model.Post;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;

import java.util.List;

public interface PostRepository extends JpaRepositoryImplementation<Post, String> {

    @Query(value = "SELECT * FROM post ORDER BY RAND() LIMIT :limit", nativeQuery = true)
    List<Post> findRandomRecords(int limit);

}