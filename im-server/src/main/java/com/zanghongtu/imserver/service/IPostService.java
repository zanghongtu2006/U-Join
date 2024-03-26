package com.zanghongtu.imserver.service;


import com.zanghongtu.imserver.model.Post;
import org.springframework.data.domain.Page;

public interface IPostService extends IBaseService<Post, String> {

    Page<Post> searchPageRandom(Integer pageIndex, Integer pageSize);

    Page<Post> searchPageByTime(Integer pageIndex, Integer pageSize);

    Page<Post> searchPageVoice(Integer pageIndex, Integer pageSize);

    Page<Post> searchPageFocus(Integer pageIndex, Integer pageSize);
}
