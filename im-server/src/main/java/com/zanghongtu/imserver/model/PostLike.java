package com.zanghongtu.imserver.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "post_like")
public class PostLike extends BaseEntity {

    private String userId;

    private String postId;

}
