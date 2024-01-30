package com.zanghongtu.imserver;

import com.zanghongtu.imserver.model.Dict;
import com.zanghongtu.imserver.model.DictItem;
import com.zanghongtu.imserver.service.IDictItemService;
import com.zanghongtu.imserver.service.IDictService;
import org.junit.jupiter.api.Test;
import org.junit.platform.commons.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

@SpringBootTest
class TestDict {
    @Autowired
    private IDictService dictService;

    @Autowired
    private IDictItemService dictItemService;

    @Test
    public void addDicts() {
        Dict dict = new Dict();
        dict.setName("寻求关系");
        dict.setCode("RELATION_TYPE");
        dictService.insert(dict);

    }

    @Test
    public void addDictItems1() {
        Optional<Dict> dict = dictService.getByCode("RELATION_TYPE");
        if (dict.isPresent()) {
            Set<String> items = new HashSet<>();
            items.add("网恋");
            items.add("找人陪伴");
            items.add("网恋奔现");
            items.add("处cp");
            for (String item :items) {
                if (StringUtils.isBlank(item)) {
                    continue;
                }
                DictItem dictItem = new DictItem();
                dictItem.setDictId(dict.get().getId());
                dictItem.setDictItemName(item);
                dictItemService.insert(dictItem);
            }
        }
    }

    @Test
    public void addDictItems0() {
        Optional<Dict> dict = dictService.getByCode("SEXUAL");
        if (dict.isPresent()) {
            Set<String> items = new HashSet<>();
            items.add("小哥哥");
            items.add("小姐姐");
            items.add("都可以");
            items.add("保密");
            for (String item :items) {
                if (StringUtils.isBlank(item)) {
                    continue;
                }
                DictItem dictItem = new DictItem();
                dictItem.setDictId(dict.get().getId());
                dictItem.setDictItemName(item);
                dictItemService.insert(dictItem);
            }
        }
    }

    @Test
    public void addDictItems() {
        Optional<Dict> dict = dictService.getByCode("PERSONALITY");
        if (dict.isPresent()) {
            Set<String> items = new HashSet<>();
            items.add("社交牛人");
            items.add("专一");
            items.add("TS");
            items.add("小杠精");
            items.add("夜场爱好者");
            items.add("多重角色");
            items.add("声控");
            items.add("选择困难");
            items.add("才华出众");
            items.add("特单纯");
            items.add("干饭王");
            items.add("妹控");
            for (String item :items) {
                if (StringUtils.isBlank(item)) {
                    continue;
                }
                DictItem dictItem = new DictItem();
                dictItem.setDictId(dict.get().getId());
                dictItem.setDictItemName(item);
                dictItemService.insert(dictItem);
            }
        }
    }

    @Test
    public void addDict3Items() {
        Optional<Dict> dict = dictService.getByCode("IREFUSE");
        if (dict.isPresent()) {
            Set<String> items = new HashSet<>();
            items.add("骚扰");
            items.add("涩涩");
            items.add("口嗨");
            items.add("假正经");
            items.add("已婚");
            items.add("PUA");
            items.add("海王");
            items.add("油腻");
            items.add("虚伪");
            items.add("大叔");
            items.add("小仙女");
            items.add("小鲜肉");
            for (String item :items) {
                if (StringUtils.isBlank(item)) {
                    continue;
                }
                DictItem dictItem = new DictItem();
                dictItem.setDictId(dict.get().getId());
                dictItem.setDictItemName(item);
                dictItemService.insert(dictItem);
            }
        }
    }

    @Test
    public void addDict2Items() {
        Optional<Dict> dict = dictService.getByCode("ILIKE");
        if (dict.isPresent()) {
            Set<String> items = new HashSet<>();
            items.add("文图");
            items.add("剧情");
            items.add("纯文字");
            items.add("角色扮演");
            items.add("蹦迪");
            items.add("吃鸡");
            items.add("K歌");
            items.add("鱼塘");
            items.add("二次元");
            items.add("Cosplay");
            items.add("露营");
            items.add("Pia戏");
            for (String item :items) {
                if (StringUtils.isBlank(item)) {
                    continue;
                }
                DictItem dictItem = new DictItem();
                dictItem.setDictId(dict.get().getId());
                dictItem.setDictItemName(item);
                dictItemService.insert(dictItem);
            }
        }
    }
}
