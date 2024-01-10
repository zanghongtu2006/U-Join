package com.zanghongtu.imserver.controller.dto.login;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class TokenRequestDTO {
    private String username;

    private String password;
    
    @JsonProperty("refresh-token")
    private String refreshToken;
}
