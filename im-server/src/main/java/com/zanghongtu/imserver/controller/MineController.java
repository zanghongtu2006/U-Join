package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.mine.PersonTagsDTO;
import com.zanghongtu.imserver.controller.dto.mine.ProfileDTO;
import com.zanghongtu.imserver.controller.dto.user.UserStatus;
import com.zanghongtu.imserver.exception.CheckException;
import com.zanghongtu.imserver.exception.PermitException;
import com.zanghongtu.imserver.model.UserInfo;
import com.zanghongtu.imserver.model.UserTag;
import com.zanghongtu.imserver.service.IUserInfoService;
import com.zanghongtu.imserver.service.IUserTagService;
import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Optional;

@Slf4j
@RestController
@RequestMapping(path = "mine")
public class MineController {
    private final IUserInfoService userInfoService;

    private final IUserTagService userTagService;

    @Autowired
    public MineController(IUserInfoService userInfoService,
                          IUserTagService userTagService) {
        this.userInfoService = userInfoService;
        this.userTagService = userTagService;
    }

    @GetMapping(path = "")
    public ProfileDTO getProfile() {
        Optional<String> uid = ReqInfoOperator.get().getUserId();
        ProfileDTO profileDTO = new ProfileDTO();
        if (uid.isPresent()) {
            UserInfo userInfo = userInfoService.getById(uid.get());
            BeanUtils.copyProperties(userInfo, profileDTO);
            profileDTO.setNickName(userInfo.getNickName());
        }
        return profileDTO;
    }

    @PostMapping(path = "tags")
    public void fillTags(@RequestBody PersonTagsDTO dto) {
        Optional<String> uid = ReqInfoOperator.get().getUserId();
        if (uid.isEmpty()) {
            throw new PermitException("用户不存在");
        }
        boolean update = false;
        UserInfo userInfo = userInfoService.getById(uid.get());
        if (StringUtils.hasText(dto.getSexual())) {
            userInfo.setSexual(dto.getSexual());
            update = true;
        }
        if (StringUtils.hasText(dto.getRelationType())) {
            userInfo.setRelationType(dto.getRelationType());
            update = true;
        }
        if (!CollectionUtils.isEmpty(dto.getPersonalities())) {
            userInfo.setPersonality(String.join(",", new HashSet<>(dto.getPersonalities())));
            update=true;
            userTagService.deleteByUIdAndCode(uid.get(), "PERSONALITY");
            for (String personality : dto.getPersonalities()) {
                UserTag userTag = new UserTag();
                userTag.setUserId(userInfo.getId());
                userTag.setTagCode("PERSONALITY");
                userTag.setTag(personality);
                userTagService.insert(userTag);
            }
        }
        if (update) {
            userInfoService.update(userInfo);
        }
        if (!CollectionUtils.isEmpty(dto.getiLikes())) {
            userTagService.deleteByUIdAndCode(uid.get(), "ILIKE");
            for (String iLike : dto.getiLikes()) {
                UserTag userTag = new UserTag();
                userTag.setUserId(userInfo.getId());
                userTag.setTagCode("ILIKE");
                userTag.setTag(iLike);
                userTagService.insert(userTag);
            }
        }
        if (!CollectionUtils.isEmpty(dto.getiRefuses())) {
            userTagService.deleteByUIdAndCode(uid.get(), "IREFUSE");
            for (String iRefuse : dto.getiRefuses()) {
                UserTag userTag = new UserTag();
                userTag.setUserId(userInfo.getId());
                userTag.setTagCode("IREFUSE");
                userTag.setTag(iRefuse);
                userTagService.insert(userTag);
            }
        }
    }

    @PostMapping(path = "profile")
    public ProfileDTO fillProfile(@RequestBody ProfileDTO dto) {
        Optional<String> uid = ReqInfoOperator.get().getUserId();
        if (uid.isEmpty()) {
            throw new PermitException("用户不存在");
        }
        if (dto.getNickName() == null) {
            throw new CheckException("昵称不能为空");
        }
        if (dto.getGender() == null) {
            throw new CheckException("性别不能为空");
        }
        if (dto.getBirthDate() == null) {
            throw new CheckException("生日不能为空");
        }
        if (dto.getHeight() == null) {
            throw new CheckException("身高不能为空");
        }
        if (dto.getWeight() == null) {
            throw new CheckException("体重不能为空");
        }
        ProfileDTO result = new ProfileDTO();
        UserInfo userInfo = userInfoService.getById(uid.get());
        userInfo.setNickName(dto.getNickName());
        userInfo.setGender(dto.getGender());

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(dto.getBirthDate());
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        Date birthDate = calendar.getTime();
        userInfo.setBirthDate(birthDate);

        userInfo.setWeight(dto.getWeight());
        userInfo.setHeight(dto.getHeight());
        userInfo.setStatus(UserStatus.PROFILE_FILLED);
        userInfoService.update(userInfo);
        BeanUtils.copyProperties(userInfo, result);
        return result;
    }
}
