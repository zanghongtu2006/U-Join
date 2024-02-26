package com.zanghongtu.imserver.service;

import com.zanghongtu.imserver.controller.dto.chat.ChatDTO;

public interface IMQService {
    void sendChatMessage(ChatDTO chatDTO);
}
