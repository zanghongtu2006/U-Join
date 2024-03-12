package com.zanghongtu.imserver.mq;

import com.alibaba.fastjson2.JSON;
import com.zanghongtu.imserver.config.MQConfig;
import com.zanghongtu.imserver.controller.dto.chat.ChatDTO;
import com.zanghongtu.imserver.service.WebSocketSessionMappingService;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.client.consumer.DefaultMQPushConsumer;
import org.apache.rocketmq.client.consumer.listener.ConsumeConcurrentlyStatus;
import org.apache.rocketmq.client.consumer.listener.MessageListenerConcurrently;
import org.apache.rocketmq.client.exception.MQClientException;
import org.apache.rocketmq.common.message.MessageExt;
import org.apache.rocketmq.spring.core.RocketMQTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.user.SimpUserRegistry;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public class WebSocketSessionHandler {
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private SimpUserRegistry simpUserRegistry;

    @Autowired
    private WebSocketSessionMappingService webSocketSessionMappingService;

    @Autowired
    private RocketMQTemplate rocketMQTemplate;

    private ConcurrentHashMap<String, List<DefaultMQPushConsumer>> consumerMap = new ConcurrentHashMap<>();

    @Autowired
    private MQConfig mqConfig;

    public void onWebSocketConnected(String userId) {
        // WebSocket连接成功后的处理逻辑
        Set<String> topics = mqConfig.getAllTopics();
        if (consumerMap.containsKey(userId)) {
            List<DefaultMQPushConsumer> consumers = consumerMap.remove(userId);
            if (!CollectionUtils.isEmpty(consumers)) {
                for (DefaultMQPushConsumer consumer : consumers) {
                    consumer.shutdown();
                }
            }
        }
        List<DefaultMQPushConsumer> newConsumers = new LinkedList<>();
        for (String topic : topics) {
            try {
                DefaultMQPushConsumer consumer = createConsumerForUser(topic, userId);
                consumer.start();
                newConsumers.add(consumer);
            } catch (MQClientException e) {
                log.error("create consumer failed.", e);
                // 处理异常，例如记录日志或发送警告
            }
        }
        consumerMap.put(userId, newConsumers);
    }

    private DefaultMQPushConsumer createConsumerForUser(String topic, String userId) throws MQClientException {
        String consumerGroup = "CHAT_GROUP"; // 所有用户共享同一个消费者组
        DefaultMQPushConsumer consumer = new DefaultMQPushConsumer(consumerGroup);
        consumer.setClientIP("192.168.168.15");
        consumer.setNamesrvAddr(rocketMQTemplate.getProducer().getNamesrvAddr()); // 设置NameServer地址
        consumer.subscribe(topic, userId); // 订阅特定用户的Tag

        consumer.registerMessageListener((MessageListenerConcurrently) (msgs, context) -> {
            for (MessageExt msg : msgs) {
                // 处理接收到的消息
                handlerMessage(msg);
            }
            return ConsumeConcurrentlyStatus.CONSUME_SUCCESS;
        });

        return consumer;
    }

    private void handlerMessage(MessageExt msg) {
        log.info("{} Receive New Messages:{} {}", Thread.currentThread().getName(), msg);
        String message = new String(msg.getBody());
        String tags = msg.getTags();
        log.info("handlerMessage: {}", message);
        ChatDTO chatDTO = JSON.parseObject(message, ChatDTO.class);
        chatDTO.setStatus(null);
        simpUserRegistry.getUsers();
        messagingTemplate.convertAndSendToUser(webSocketSessionMappingService.getSessionId(tags), "/topic/chat", chatDTO);
    }
}
