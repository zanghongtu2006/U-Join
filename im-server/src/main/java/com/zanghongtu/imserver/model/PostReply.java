package com.zanghongtu.imserver.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "post_reply")
public class PostReply extends BaseEntity {

    private String userId;

    /**
     * 在某个朋友圈下的回复，指向原帖
     */
    private String postId;

    /**
     * 对某个回复进行回复的ID
     * null 则为一级答复
     */
    private String parentId;

    private String parentUserId;

    @Column(columnDefinition = "TEXT")
    private String content;

    private List<String> imageUrls;

    private String videoUrl;

    private String audioUrl;

    private Integer likeCount;

    private Integer replyCount;

    private String location;

}
