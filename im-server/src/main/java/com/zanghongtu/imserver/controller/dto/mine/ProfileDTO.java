package com.zanghongtu.imserver.controller.dto.mine;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.zanghongtu.imserver.controller.dto.user.Gender;
import com.zanghongtu.imserver.controller.dto.user.UserStatus;
import lombok.Data;

import java.util.Date;
import java.util.List;
import java.util.stream.Stream;

@Data
public class ProfileDTO {
    private String id;

    private String nickName;

    private String avatar = "https://placekitten.com/200/200";

    private UserStatus status = UserStatus.REGISTERD;

    private int fansCount = 0;

    private int focusCount = 0;

    private int visitorsCount = 0;

    private Gender gender;

    private Date birthDate;

    private Double height;

    private Double weight;

    private List<Integer> taskStatus = Stream.generate(() -> 0).limit(7).toList();

    private int level = 0;

}
