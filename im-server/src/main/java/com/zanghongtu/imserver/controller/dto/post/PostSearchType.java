package com.zanghongtu.imserver.controller.dto.post;

import lombok.Getter;

@Getter
public enum PostSearchType {

    /**
     * 发现
     */
    RANDOM(0),
    /**
     * 最新
     */
    LATEST(1),
    /**
     * 声控
     */
    VOICE(2),
    /**
     * 关注
     */
    FOCUS(3);

    private final Integer code;
    PostSearchType(Integer code) {
        this.code = code;
    }

}
