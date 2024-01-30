package com.zanghongtu.imserver.service;


import com.zanghongtu.imserver.model.Dict;

import java.util.Optional;

public interface IDictService extends IBaseService<Dict, String> {
    Optional<Dict> getByCode(String code);

}
