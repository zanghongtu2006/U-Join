package com.zanghongtu.imserver.threadlocal;

import lombok.Data;

import java.util.Optional;
import java.util.UUID;

@Data
public class ReqInfo {
    private String requestId;

    private int errorCode;

    private String errorMsg;

    private Optional<String> userName;

    private Optional<String> userId;

    public ReqInfo() {
        this.requestId = UUID.randomUUID().toString();
    }
}
