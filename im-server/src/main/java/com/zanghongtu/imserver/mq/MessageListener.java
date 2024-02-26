//package com.zanghongtu.imserver.mq;
//
//import com.zanghongtu.imserver.config.Constants;
//import com.zanghongtu.imserver.config.MQConfig;
//import com.zanghongtu.imserver.service.IConversationUserService;
//import lombok.extern.slf4j.Slf4j;
//import org.apache.rocketmq.client.consumer.DefaultMQPushConsumer;
//import org.apache.rocketmq.client.consumer.listener.ConsumeConcurrentlyStatus;
//import org.apache.rocketmq.client.consumer.listener.MessageListenerConcurrently;
//import org.apache.rocketmq.client.exception.MQClientException;
//import org.apache.rocketmq.common.message.MessageExt;
//import org.apache.rocketmq.spring.core.RocketMQListener;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import java.util.Map;
//import java.util.Set;
//import java.util.concurrent.ConcurrentHashMap;
//
//@Slf4j
//@Service
//public class MessageListener implements RocketMQListener<String> {
//    @Autowired
//    private MQConfig mqConfig;
//
//    @Autowired
//    private IConversationUserService conversationUserService;
//
//    // 用于存储动态创建的消费者实例
//    // {topic, MQPushConsumer}
//    private final Map<String, DefaultMQPushConsumer> consumerMap = new ConcurrentHashMap<>();
//    private final Map<String, Set<String>> connectedUsers = new ConcurrentHashMap<>();
//
//    public void createConsumers() {
//        Set<String> topics = mqConfig.getAllTopics();
//        for (String topic : topics) {
//            String tags = String.join("||", Constants.USER_SESSION_MAP.keySet());
//            if (!consumerMap.containsKey(topic)) {
//                createConsumer(topic, tags);
//            } else {
//                DefaultMQPushConsumer consumer = consumerMap.get(topic);
//                try {
//                    consumer.unsubscribe(topic);
//                    consumer.subscribe(topic, tags); // 订阅主题和标签
//                } catch (MQClientException e) {
//                    log.error("Register MQ Consumer failed.", e);
//                }
//            }
//        }
//    }
//
//    private void createConsumer(String topic, String tags) {
//        DefaultMQPushConsumer consumer = new DefaultMQPushConsumer("CHAT_GROUP");
//        consumer.setClientIP("192.168.168.15");
//        consumer.setNamesrvAddr(mqConfig.getNameServer()); // 设置NameServer地址
//        try {
//            consumer.subscribe(topic, tags); // 订阅主题和标签
//            MessageListenerConcurrently messageListenerConcurrently = (msgs, consumeConcurrentlyContext) -> {
//                msgs.forEach(this::onMessage);
//                return ConsumeConcurrentlyStatus.CONSUME_SUCCESS;
//            };
//            consumer.registerMessageListener(messageListenerConcurrently);
//            consumer.start();
//            consumerMap.put(topic, consumer);
//            log.info("Started consumer for topic: {}, tags: {}", topic, tags);
//        } catch (MQClientException e) {
//            log.error("Register MQ Consumer failed.", e);
//        }
//    }
//
//    private void onMessage(MessageExt msg) {
//        System.out.println("RECV: " + new String(msg.getBody()));
//    }
//
////    public void shutdownConsumer(String group) {
////        DefaultMQPushConsumer consumer = consumerMap.remove(group);
////        if (consumer != null) {
////            consumer.shutdown();
////            log.info("Shutdown consumer for topic: {}, tags: {}", topic, tags);
////        }
////    }
//
//    @Override
//    public void onMessage(String message) {
//        // 该方法体可能需要根据实际情况进行调整
//        System.out.println("Received message: " + message);
//    }
//}
