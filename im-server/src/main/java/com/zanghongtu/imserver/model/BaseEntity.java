package com.zanghongtu.imserver.model;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;

import java.io.Serializable;
import java.util.Date;


@Data
@MappedSuperclass
public class BaseEntity implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @GenericGenerator(
            name = "UUID",
            strategy = "org.hibernate.id.UUIDGenerator"
    )
    @Column(name = "id", updatable = false, nullable = false, length = 64)
    private String id;

    @Column(columnDefinition = "datetime DEFAULT CURRENT_TIMESTAMP()")
    private Date createTime;

    @Column(columnDefinition = "datetime DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()")
    private Date updateTime;

    @Column(length = 64)
    private String createdBy;

    @Column(length = 64)
    private String updatedBy;

    @Column(nullable = false, columnDefinition = "TINYINT(1) DEFAULT 1")
    private Boolean available = true;
}
