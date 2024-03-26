package com.zanghongtu.imserver.model;

import com.zanghongtu.imserver.controller.dto.user.Gender;
import com.zanghongtu.imserver.controller.dto.user.UserStatus;
import com.zanghongtu.imserver.controller.dto.user.UserType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;
import java.util.Set;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "user_info")
public class UserInfo extends BaseEntity {

    private String fullName;

    private String nickName;

    @Column(name = "avatar", columnDefinition = "VARCHAR(255) DEFAULT 'https://placekitten.com/200/200'")
    private String avatar;

    private String mobile;

    private String email;

    private Gender gender;

    private Date birthDate;

    private UserStatus status;

    private Integer height;

    private Integer age;

    private Double weight;

    private String personality;

    private UserType type;

    private String sexual;

    private String relationType;

    private String authUserId;

    private String wxId;
}
