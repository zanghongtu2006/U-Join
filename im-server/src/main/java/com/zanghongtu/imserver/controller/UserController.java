package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.page.PageRequest;
import com.zanghongtu.imserver.controller.dto.page.PageResponse;
import com.zanghongtu.imserver.controller.dto.user.UserInfoDTO;
import com.zanghongtu.imserver.model.UserInfo;
import com.zanghongtu.imserver.service.IUserInfoService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("users")
public class UserController extends BaseController {
    @Autowired
    private IUserInfoService userInfoService;

    @GetMapping(path = "")
    public PageResponse<UserInfoDTO> search(UserInfo userInfo, PageRequest pageRequest) {
        log.info("in user list");
        Page<UserInfo> pageResult = userInfoService.search(Example.of(userInfo), pageRequest.getPageIndex(), pageRequest.getPageSize());
        return model2dto(pageResult, UserInfoDTO.class);
    }
}
