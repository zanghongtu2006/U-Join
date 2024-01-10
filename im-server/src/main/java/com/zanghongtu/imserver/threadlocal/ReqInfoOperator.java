package com.zanghongtu.imserver.threadlocal;

public class ReqInfoOperator {
    private static final ThreadLocal<ReqInfo> REQ_INFO_THREAD_LOCAL = new ThreadLocal<>();

    public static ReqInfo get() {
        ReqInfo reqInfo = REQ_INFO_THREAD_LOCAL.get();
        if (reqInfo == null) {
            reqInfo = new ReqInfo();
        }
        set(reqInfo);
        return REQ_INFO_THREAD_LOCAL.get();
    }

    public static void set(ReqInfo reqInfoThreadLocal) {
        REQ_INFO_THREAD_LOCAL.set(reqInfoThreadLocal);
    }

    public static void remove() {
        REQ_INFO_THREAD_LOCAL.remove();
    }
}
