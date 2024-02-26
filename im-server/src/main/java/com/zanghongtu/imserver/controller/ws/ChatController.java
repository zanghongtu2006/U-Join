package com.zanghongtu.imserver.controller.ws;

import com.zanghongtu.imserver.controller.dto.chat.AdditionalInfoDTO;
import com.zanghongtu.imserver.controller.dto.chat.ChatDTO;
import com.zanghongtu.imserver.controller.dto.chat.MessageType;
import com.zanghongtu.imserver.service.IMQService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;

@Slf4j
@Controller
public class ChatController {

    private final IMQService mqService;

    public ChatController(IMQService mqService) {
        this.mqService = mqService;
    }

    @MessageMapping("/chat")
    @SendToUser(value = "/topic/chat-reply")
    public ChatDTO heartbeat(ChatDTO chatDTO) {
        log.info("Recv chat: {}", chatDTO);
        //dispatch chat dto
        mqService.sendChatMessage(chatDTO);
        //from -> to
        AdditionalInfoDTO additionalInfo = new AdditionalInfoDTO();
        additionalInfo.setReplyToMessageId(chatDTO.getMessageId());
        ChatDTO reply = new ChatDTO();
        reply.setAdditionalInfo(additionalInfo);
        reply.setMessageType(MessageType.CHAT_REPLY);
        return reply;
    }

}
