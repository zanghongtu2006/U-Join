package com.zanghongtu.imserver.controller.dto.mine;

import lombok.Data;

import java.util.List;
import java.util.stream.Stream;

@Data
public class ProfileDTO {
    private String id;

    private String nickName;

    private String avatar;

    private int fansCount = 0;

    private int focusCount = 0;

    private int visitorsCount = 0;

    private List<Integer> taskStatus = Stream.generate(() -> 0).limit(7).toList();

    private int level = 0;

}
