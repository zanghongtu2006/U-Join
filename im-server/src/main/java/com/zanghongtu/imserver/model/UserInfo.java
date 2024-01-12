package com.zanghongtu.imserver.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "user")
public class UserInfo extends BaseEntity {

    private String fullName;

    private String nickName;

    private String avatar;

    private String mobile;

    private String email;

    private String authUserId;

    private String wxId;
}
