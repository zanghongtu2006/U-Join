package com.zanghongtu.imserver.controller.dto.mine;

import lombok.Data;

import java.util.List;

@Data
public class PersonTagsDTO {
    List<String> personalities;

    List<String> iLikes;

    List<String> iRefuses;

    String sexual;

    String relationType;

    public List<String> getiLikes() {
        return iLikes;
    }

    public void setiLikes(List<String> iLikes) {
        this.iLikes = iLikes;
    }

    public List<String> getiRefuses() {
        return iRefuses;
    }

    public void setiRefuses(List<String> iRefuses) {
        this.iRefuses = iRefuses;
    }
}
