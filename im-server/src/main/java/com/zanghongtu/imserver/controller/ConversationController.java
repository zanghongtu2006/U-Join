package com.zanghongtu.imserver.controller;

import com.zanghongtu.imserver.controller.dto.ConversationDTO;
import com.zanghongtu.imserver.controller.dto.chat.ConversationType;
import com.zanghongtu.imserver.controller.dto.page.PageRequest;
import com.zanghongtu.imserver.controller.dto.page.PageResponse;
import com.zanghongtu.imserver.exception.PermitException;
import com.zanghongtu.imserver.model.ConversationUser;
import com.zanghongtu.imserver.service.IConversationService;
import com.zanghongtu.imserver.service.IConversationUserService;
import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import jakarta.persistence.criteria.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

@Slf4j
@RestController
@RequestMapping(path = "conversations")
public class ConversationController extends BaseController {
    private final IConversationService conversationService;

    private final IConversationUserService conversationUserService;

    @Autowired
    public ConversationController(IConversationService conversationService,
                                  IConversationUserService conversationUserService
    ) {
        this.conversationService = conversationService;
        this.conversationUserService = conversationUserService;
    }

    @GetMapping(path = "latest")
    public PageResponse<ConversationDTO> latestConversations(PageRequest pageRequest) {
        Optional<String> uid = ReqInfoOperator.get().getUserId();
        if (uid.isEmpty()) {
            throw new PermitException("用户不存在");
        }
        List<ConversationUser> conversationUsers = new LinkedList<>();
        //第一页，先查询所有置顶
        if (pageRequest.getPageIndex() == 0) {
            ConversationUser systemExample = new ConversationUser();
            systemExample.setType(ConversationType.SYSTEM);
            systemExample.setUserId(uid.get());
            conversationUsers.addAll(conversationUserService.findAll(Example.of(systemExample)));

            ConversationUser onTopExample = new ConversationUser();
            onTopExample.setUserId(uid.get());
            onTopExample.setOnTop(true);
            conversationUsers.addAll(conversationUserService.findAll(Example.of(onTopExample)));
        }
        Specification<ConversationUser> spec = (root, criteriaQuery, criteriaBuilder) -> {
            Predicate p1 = criteriaBuilder.equal(root.get("userId"), uid.get());
            Predicate p2 = criteriaBuilder.equal(root.get("onTop"), false);
            Predicate p3 = criteriaBuilder.notEqual(root.get("type"), ConversationType.SYSTEM);
            Predicate p = criteriaBuilder.and(p1);
            p = criteriaBuilder.and(p, p2);
            p = criteriaBuilder.and(p, p3);
            return p;
        };
        Page<ConversationUser> conversationUserPage =
                (conversationUserService.search(spec, pageRequest.getPageIndex(), pageRequest.getPageSize()));
        conversationUsers.addAll(conversationUserPage.getContent());
        PageResponse<ConversationDTO> response = model2dto(conversationUserPage, ConversationDTO.class);
        response.setRows(model2dto(conversationUsers));
        return response;
    }

    private List<ConversationDTO> model2dto(List<ConversationUser> models) {
//        Map<String, Conversation> conversationMap = conversationService.findAllById(
//                models.stream().map(ConversationUser::getConversationId).collect(Collectors.toSet())
//        ).stream().collect(Collectors.toMap(Conversation::getConversationId, a->a, (k1,k2)->k1));
        List<ConversationDTO> dtos = new LinkedList<>();
        for (ConversationUser model : models) {
            dtos.add(model2dto(model));
        }
        return dtos;
    }

    private ConversationDTO model2dto(ConversationUser model) {
        ConversationDTO dto = new ConversationDTO();
        dto.setConversationId(model.getConversationId());
        dto.setShortConversationId(model.getConversationId().substring(0, 8) + "-" + model.getConversationId().substring(32, 40));
        dto.setAvatar(model.getAvatar());
        dto.setNickName(model.getNickName());
        dto.setLastMessage("hello world");
        dto.setUnReadCount(4);
        return dto;
    }
}


