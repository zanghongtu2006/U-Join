package com.zanghongtu.imserver.service;

import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;

public interface IRedisService {
    boolean set(String key, Object value);

    boolean set(String key, Object value, Long expireTime, TimeUnit timeUnit);

    void remove(String... keys);

    void removePattern(String pattern);

    void remove(String key);

    boolean exists(String key);

    Object get(String key);

    void hmSet(String key, Object hashKey, Object value);

    Object hmGet(String key, Object hashKey);

    void lPush(String k, Object v);

    List<Object> lRange(String k, long l, long l1);

    void add(String key, Object value);

    Set<Object> setMembers(String key);

    void zAdd(String key, Object value, double scoure);

    Set<Object> rangeByScore(String key, double scoure, double scoure1);
}
