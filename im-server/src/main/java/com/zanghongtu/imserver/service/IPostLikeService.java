package com.zanghongtu.imserver.service;


import com.zanghongtu.imserver.model.PostLike;

import java.util.List;
import java.util.Set;

public interface IPostLikeService extends IBaseService<PostLike, String> {
    PostLike likeOrUnlike(String postId, String userId);

    List<PostLike> searchByPostIds(Set<String> postIds, String userId);
}
