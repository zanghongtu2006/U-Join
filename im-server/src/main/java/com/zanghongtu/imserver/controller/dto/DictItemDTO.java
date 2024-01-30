package com.zanghongtu.imserver.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DictItemDTO {
    private String dictCode;

    private String dictItemName;

    private String dictItemCode;

    public DictItemDTO(String dictItemName, String dictItemCode) {

    }
}
