package com.zanghongtu.imserver.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
@Entity
@Table(name = "user_tag")
public class UserTag extends BaseEntity {

    @Column(nullable = false)
    private String userId;

    @Column(nullable = false)
    private String tag;

    @Column(nullable = false)
    private String tagCode;

}
