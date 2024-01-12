package com.zanghongtu.imserver.controller.dto.page;

import lombok.Data;
import org.springframework.data.domain.Sort;

import java.util.Set;

@Data
public class PageRequest {
    /**
     * 传入参赛从1开始，转换为Hibernate2.x后从0开始
     */
    private Integer pageIndex;

    private Integer pageSize = 10;

    private Set<String> sortFields;

    private Sort sort;

    public Integer getPageIndex() {
        return pageIndex == null ? 0 : pageIndex - 1;
    }

    public Integer getPageSize() {
        return pageSize == null ? 10 : pageSize;
    }
}
