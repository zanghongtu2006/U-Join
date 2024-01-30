package com.zanghongtu.imserver.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "dict")
public class Dict extends BaseEntity {

    @Column(unique = true)
    private String name;

    @Column(unique = true)
    private String code;

    private String description;

}
