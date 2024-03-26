package com.zanghongtu.imserver.controller.dto.post;

import com.zanghongtu.imserver.controller.dto.user.UserInfoDTO;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class PostDTO {
    private String id;

    private String userId;

    private UserInfoDTO userInfo;

    private String content;

    private Boolean like;

    /**
     * 优先级，图片，视频，音频，有就放弃后面的
     */
    private List<String> imageUrls;

    private String imageIds;

    private String videoUrl;

    private String audioUrl;

    private Integer likeCount;

    private Integer replyCount;

    private String location;

    private Date createTime;

    private List<PostReplyDTO> replies;
}
