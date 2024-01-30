package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.DictItemDTO;
import com.zanghongtu.imserver.model.Dict;
import com.zanghongtu.imserver.model.DictItem;
import com.zanghongtu.imserver.service.IDictItemService;
import com.zanghongtu.imserver.service.IDictService;
import jakarta.persistence.criteria.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequestMapping(path = "dicts")
public class DictController extends BaseController {
    @Autowired
    private IDictService dictService;

    @Autowired
    private IDictItemService dictItemService;

    @GetMapping(path = "items")
    public Map<String, List<DictItemDTO>> searchItemByCodes(@RequestParam(name = "code", required = false, defaultValue = "") Set<String> codes) {
        if (CollectionUtils.isEmpty(codes)) {
            return new HashMap<>();
        }
        Specification<Dict> spec = (root, criteriaQuery, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(root.get("code").in(codes));
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
        List<Dict> dictList = dictService.findAll(spec);
        Set<String> dictIds = dictList.stream().map(Dict::getId).collect(Collectors.toSet());
        if (CollectionUtils.isEmpty(dictIds)) {
            return new HashMap<>();
        }
        Specification<DictItem> itemSpec = (root, criteriaQuery, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(root.get("dictId").in(dictIds));
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
        List<DictItem> dictItems = dictItemService.findAll(itemSpec);
        List<DictItemDTO> dtos = model2dto(dictItems, DictItemDTO.class);
        return dtos.stream()
                .collect(Collectors.groupingBy(
                        DictItemDTO::getDictCode,
                        Collectors.mapping(
                                a -> a,
                                Collectors.toList()
                        )
                ));
    }

    @GetMapping(path = "itemNames")
    public Map<String, Set<String>> searchByCodes(@RequestParam(name = "code", required = false, defaultValue = "") Set<String> codes) {
        if (CollectionUtils.isEmpty(codes)) {
            return new HashMap<>();
        }
        Specification<Dict> spec = (root, criteriaQuery, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(root.get("code").in(codes));
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
        List<Dict> dictList = dictService.findAll(spec);
        Set<String> dictIds = dictList.stream().map(Dict::getId).collect(Collectors.toSet());
        if (CollectionUtils.isEmpty(dictIds)) {
            return new HashMap<>();
        }
        Specification<DictItem> itemSpec = (root, criteriaQuery, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(root.get("dictId").in(dictIds));
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
        List<DictItem> dictItems = dictItemService.findAll(itemSpec);
        return dictItems.stream()
                .collect(Collectors.groupingBy(DictItem::getDictCode,
                        Collectors.mapping(DictItem::getDictItemName, Collectors.toSet())));
    }

    @GetMapping(path = "iLike")
    public Set<String> getILike() {
        return new HashSet<>();
    }

    @GetMapping(path = "iRefuse")
    public Set<String> getIRefuse() {
        return new HashSet<>();
    }
}
