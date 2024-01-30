package com.zanghongtu.imserver.controller.dto.user;

import lombok.Data;

@Data
public class UserInfoDTO {

    private String id;

    private String fullName;

    private String nickName;

    private String avatar = "https://placekitten.com/200/200";

    private String mobile;

    private String email;

}
