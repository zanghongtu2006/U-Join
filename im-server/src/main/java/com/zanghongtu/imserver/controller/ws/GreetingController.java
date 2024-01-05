package com.zanghongtu.imserver.controller.ws;

import com.zanghongtu.imserver.controller.dto.HelloMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

@Slf4j
@Controller
public class GreetingController {

    @MessageMapping("/hello")
    @SendToUser("/topic/greetings")
    public HelloMessage greeting(HelloMessage message) throws Exception {
        Thread.sleep(1000); // simulated delay
        log.info("Recv {}", message);
        return new HelloMessage("Hello, " + HtmlUtils.htmlEscape(message.getName()) + "!");
    }

}
