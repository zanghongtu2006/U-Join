package com.zanghongtu.imserver.controller.ws;

import com.zanghongtu.imserver.controller.dto.chat.AdditionalInfoDTO;
import com.zanghongtu.imserver.controller.dto.chat.ChatDTO;
import com.zanghongtu.imserver.controller.dto.chat.MessageType;
import com.zanghongtu.imserver.exception.BusinessException;
import com.zanghongtu.imserver.model.Conversation;
import com.zanghongtu.imserver.service.IConversationService;
import com.zanghongtu.imserver.service.IMQService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;

import java.util.Date;
import java.util.Optional;

@Slf4j
@Controller
public class ChatController {

    private final IMQService mqService;

    private final IConversationService conversationService;

    public ChatController(IMQService mqService, IConversationService conversationService) {
        this.mqService = mqService;
        this.conversationService = conversationService;
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

        Optional<Conversation> conversation = conversationService.getByConversationId(chatDTO.getConversationId());
        conversation.ifPresent(value -> conversationService.update(getConversation(chatDTO, value)));
        return reply;
    }

    private static Conversation getConversation(ChatDTO chatDTO, Conversation conversation) {
        switch (chatDTO.getContent().getType()) {
            case IMAGE:
                conversation.setLastMessage("[图片]");
                break;
            case RED_ENVELOPE:
                conversation.setLastMessage("[红包]");
                break;
            case AUDIO:
                conversation.setLastMessage("[音频]");
                break;
            case VIDEO:
                conversation.setLastMessage("[视频]");
                break;
            default:
                conversation.setLastMessage(chatDTO.getContent().getText());
                break;
        }
        conversation.setLastUpdateTime(new Date(chatDTO.getTimestamp()));
        return conversation;
    }

}
