package com.zanghongtu.imserver.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "image")
public class Image extends BaseEntity {

    @Column(columnDefinition = "VARCHAR(64)")
    private String userId;

    @Column(columnDefinition = "TEXT")
    private String url;

    private Integer sortOrder;

}
