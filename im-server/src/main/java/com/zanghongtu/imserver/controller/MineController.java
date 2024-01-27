package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.mine.ProfileDTO;
import com.zanghongtu.imserver.model.UserInfo;
import com.zanghongtu.imserver.service.IUserInfoService;
import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping(path = "mine")
public class MineController {
    private final IUserInfoService userInfoService;

    @Autowired
    public MineController(IUserInfoService userInfoService) {
        this.userInfoService = userInfoService;
    }

    @GetMapping(path = "")
    public ProfileDTO getProfile() {
        Optional<String> uid = ReqInfoOperator.get().getUserId();
        ProfileDTO profileDTO = new ProfileDTO();
        if (uid.isPresent()) {
            UserInfo userInfo = userInfoService.getById(uid.get());
            BeanUtils.copyProperties(userInfo, profileDTO);
            profileDTO.setNickName(userInfo.getNickName());
            profileDTO.setId(userInfo.getFullName());
        }
        return profileDTO;
    }
}
