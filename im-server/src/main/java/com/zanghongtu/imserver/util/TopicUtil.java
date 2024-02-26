package com.zanghongtu.imserver.util;

import lombok.extern.slf4j.Slf4j;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@Slf4j
public class TopicUtil {
    public static int hashToTopicIndex(String conversationId, int topicCount) {
        // 使用SHA-256计算conversationId的哈希值
        MessageDigest digest = null;
        try {
            digest = MessageDigest.getInstance("SHA-256");
        } catch (NoSuchAlgorithmException e) {
            log.error("Can not generate topic.", e);
            return 0;
        }
        byte[] hash = digest.digest(conversationId.getBytes(StandardCharsets.UTF_8));

        // 将哈希值的前4个字节转换为一个整数（为简化示例，实际可以选择更合适的方法来利用完整的哈希值）
        int hashInt = ((hash[0] & 0xFF) << 24) | ((hash[1] & 0xFF) << 16) | ((hash[2] & 0xFF) << 8) | (hash[3] & 0xFF);

        // 使用绝对值确保结果为正，然后对topicCount取模，得到一个0到(topicCount-1)的索引
        return Math.abs(hashInt) % topicCount;
    }
}
