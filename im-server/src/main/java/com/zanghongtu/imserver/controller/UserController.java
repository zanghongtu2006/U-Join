package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.page.PageRequest;
import com.zanghongtu.imserver.controller.dto.page.PageResponse;
import com.zanghongtu.imserver.controller.dto.user.UserInfoDTO;
import com.zanghongtu.imserver.controller.dto.user.UserType;
import com.zanghongtu.imserver.model.UserInfo;
import com.zanghongtu.imserver.service.IUserInfoService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedList;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("users")
public class UserController extends BaseController {
    @Autowired
    private IUserInfoService userInfoService;

    @GetMapping(path = "contacts")
    public PageResponse<UserInfoDTO> search(UserInfoDTO userInfoDTO, PageRequest pageRequest) {
        UserInfo userInfo = new UserInfo();
        BeanUtils.copyProperties(userInfoDTO, userInfo);
        Page<UserInfo> pageResult = userInfoService.search(Example.of(userInfo), pageRequest.getPageIndex(), pageRequest.getPageSize());
        PageResponse<UserInfoDTO> response = model2dto(pageResult, UserInfoDTO.class);
        if (pageRequest.getPageIndex() == 0) {
            UserInfo client = userInfoService.getClient();
            List<UserInfo> userInfos = new LinkedList<>();
            userInfos.add(client);
            List<UserInfo> result = pageResult.getContent();
            userInfos.addAll(result);
            List<UserInfoDTO> newResults = model2dto(userInfos, UserInfoDTO.class);
            response.setRows(newResults);
        }
        return response;
    }
}
