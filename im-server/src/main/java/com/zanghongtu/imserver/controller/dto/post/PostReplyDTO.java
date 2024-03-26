package com.zanghongtu.imserver.controller.dto.post;

import com.zanghongtu.imserver.controller.dto.user.UserInfoDTO;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class PostReplyDTO {
    private String id;

    private UserInfoDTO userInfo;

    /**
     * 主贴
     */
    private String postId;

    /**
     * reply.Id 针对哪一条的评论
     */
    private String parentId;

    /**
     * reply.userId,reply.userNickName
     */
    private UserInfoDTO parentUserInfo;

    /**
     * 以下是基础信息
     * 优先级，图片，视频，音频，有就放弃后面的
     */
    private String content;

    private List<String> imageUrls;

    private String videoUrl;

    private String audioUrl;

    private Integer likeCount;

    private Integer replyCount;

    private String location;

    private Date createTime;
}
