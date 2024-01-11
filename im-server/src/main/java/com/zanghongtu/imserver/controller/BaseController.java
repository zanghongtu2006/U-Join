package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.page.PageResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;

import java.lang.reflect.InvocationTargetException;
import java.util.LinkedList;
import java.util.List;

@Slf4j
public class BaseController {
    public <T, M> PageResponse<T> model2dto(Page<M> model, Class<T> clazz) {
        PageResponse<T> pageResponse = new PageResponse<>();
        pageResponse.setPage(model.getPageable().getPageNumber());
        pageResponse.setPageSize(model.getPageable().getPageSize());
        pageResponse.setTotal(model.getTotalElements());
        pageResponse.setRows(model2dto(model.getContent(), clazz));
        return pageResponse;
    }

    public <T, M> List<T> model2dto(List<M> models, Class<T> clazz) {
        List<T> dtos = new LinkedList<>();
        for (M model : models) {
            T dto = model2dto(model, clazz);
            if (dto != null) {
                dtos.add(dto);
            }
        }
        return dtos;
    }

    /**
     * convert model to dto
     *
     * @param model model
     * @param clazz DTO class
     */
    public <T, M> T model2dto(M model, Class<T> clazz) {
        try {
            T dto = clazz.getDeclaredConstructor().newInstance();
            BeanUtils.copyProperties(model, dto);
            return dto;
        } catch (InstantiationException | InvocationTargetException | IllegalAccessException |
                 NoSuchMethodException e) {
            log.error("Convert model to dto failed.", e);
        }
        return null;
    }
}
