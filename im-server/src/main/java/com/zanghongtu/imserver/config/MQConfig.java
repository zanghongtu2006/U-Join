package com.zanghongtu.imserver.config;

import com.zanghongtu.imserver.util.TopicUtil;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

@Component
@Data
@ConfigurationProperties(prefix = "mq")
public class MQConfig {
    private String topicPrefix = "chat";

    private int topicNumber = 8;

    private String nameServer;

    public String getTopic(String conversationId) {
        return this.topicPrefix + "-" + TopicUtil.hashToTopicIndex(conversationId, this.topicNumber);
    }

    public Set<String> getAllTopics() {
        Set<String> topics = new HashSet<>();
        for (int i = 0; i < topicNumber; i++) {
            topics.add(this.topicPrefix + "-" + i);
        }
        return topics;
    }
}
