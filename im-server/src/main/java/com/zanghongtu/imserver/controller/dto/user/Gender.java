package com.zanghongtu.imserver.controller.dto.user;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import lombok.Getter;

import java.io.IOException;

@Getter
public enum Gender {
    UNKNOWN(0),
    MALE(1),
    FEMALE(2);

    final int code;

    Gender(int code) {
        this.code = code;
    }

}
