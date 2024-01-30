package com.zanghongtu.imserver.model;

import com.zanghongtu.imserver.controller.dto.user.Gender;
import com.zanghongtu.imserver.controller.dto.user.UserStatus;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;
import java.util.Set;

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

    private Gender gender;

    private Date birthDate;

    private UserStatus status;

    private Double height;

    private Double weight;

    private String personality;

    String sexual;

    String relationType;

    private String authUserId;

    private String wxId;
}
