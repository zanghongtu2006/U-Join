package com.zanghongtu.imserver.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "dict_item")
public class DictItem extends BaseEntity {

    @Column(nullable = false)
    private String dictId;

    @Column(nullable = false)
    private String dictCode;

    @Column(nullable = false)
    private String dictItemName;

    private String dictItemCode;

    private String dictItemDescription;
}
