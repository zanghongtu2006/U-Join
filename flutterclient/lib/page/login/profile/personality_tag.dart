import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterclient/page/login/profile/social_trend.dart';
import 'package:oktoast/oktoast.dart';

import '../../../util/api_service.dart';
import 'progress.dart';

class PersonalityTagPage extends StatefulWidget {
  @override
  _PersonalityTagPageState createState() => _PersonalityTagPageState();
}

class _PersonalityTagPageState extends State<PersonalityTagPage> {
  // 假设您已经从图像中提取了所有的标签文本
  late List<String> iamTags = [
    "专一",
    "妹控",
    "干饭王",
    "多重角色",
    "社交牛人",
    "选择困难",
    "特单纯",
    "小杠精",
    "声控",
    "才华出众",
    "夜场爱好者",
    "TS"
  ];
  late List<String> ilikeTags = [
    "露营",
    "K歌",
    "Pia戏",
    "剧情",
    "吃鸡",
    "蹦迪",
    "纯文字",
    "角色扮演",
    "二次元",
    "文图",
    "Cosplay",
    "鱼塘"
  ];
  late List<String> irefuseTags = [
    "虚伪",
    "小鲜肉",
    "已婚",
    "骚扰",
    "大叔",
    "假正经",
    "海王",
    "小仙女",
    "PUA",
    "涩涩",
    "油腻",
    "口嗨"
  ];

  // 标签选中状态
  Map<String, bool> selectedTags = {};

  @override
  void initState() {
    super.initState();
    _fetchTags();
    // 初始化标签选中状态为false
    for (var tag in [...iamTags, ...ilikeTags, ...irefuseTags]) {
      selectedTags[tag] = false;
    }
  }

  bool validateSelections() {
    return iamTags.where((tag) => selectedTags[tag] == true).isNotEmpty &&
        iamTags.where((tag) => selectedTags[tag] == true).length <= 5 &&
        ilikeTags.where((tag) => selectedTags[tag] == true).isNotEmpty &&
        ilikeTags.where((tag) => selectedTags[tag] == true).length <= 5 &&
        irefuseTags.where((tag) => selectedTags[tag] == true).isNotEmpty &&
        irefuseTags.where((tag) => selectedTags[tag] == true).length <= 5;
  }

  Future<void> _fetchTags() async {
    final Map<String, String> params = {'code': 'PERSONALITY,ILIKE,IREFUSE'};
    var response = await ApiService().get("/dicts/itemNames", params: params);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      // 使用新数据更新标签列表
      List<String> newIamTags = List<String>.from(data['PERSONALITY']);
      List<String> newIlikeTags = List<String>.from(data['ILIKE']);
      List<String> newIrefuseTags = List<String>.from(data['IREFUSE']);

      // 更新选中状态映射
      for (var tag in [...newIamTags, ...newIlikeTags, ...newIrefuseTags]) {
        if (!selectedTags.containsKey(tag)) {
          selectedTags[tag] = false;
        }
      }

      setState(() {
        iamTags = newIamTags;
        ilikeTags = newIlikeTags;
        irefuseTags = newIrefuseTags;
      });
    }
  }

  int countSelectedTags(List<String> tags) {
    return tags.where((tag) => selectedTags[tag] == true).length;
  }

  Widget buildTagsSection(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 4,
              ),
              const Text('（可以选择1-5项）',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Wrap(
          spacing: 8.0, // 横向间隔
          runSpacing: 4.0, // 纵向间隔
          children: tags
              .map((tag) => ChoiceChip(
                    label: Text(tag),
                    labelStyle: TextStyle(
                      color: selectedTags[tag] ?? false
                          ? Colors.white
                          : Colors.black, // 根据是否选中改变文字颜色
                    ),
                    selected: selectedTags[tag] ?? false,
                    selectedColor: Colors.indigoAccent,
                    // 选中时的背景颜色
                    onSelected: (bool selected) {
                      if (selected && countSelectedTags(tags) >= 5) {
                        showToast('每个选项选择数量必须在1到5个之间',
                            duration: const Duration(seconds: 2),
                            position: ToastPosition.bottom,
                            backgroundColor: Colors.black12,
                            textPadding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            textStyle: const TextStyle(color: Colors.black));
                      } else {
                        setState(() {
                          selectedTags[tag] = selected;
                        });
                      }
                    },
                    backgroundColor: Colors.transparent,
                    // 未选中时的背景颜色
                    showCheckmark: false,
                    // 不显示对号
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 设置圆角的大小
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mine/bg_color.png'), // 图片路径
              fit: BoxFit.cover, // 填充模式
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 240,
                    child: CustomStepProgress(
                      totalSteps: 4,
                      currentStep: 3,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('设置您的性格标签',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('展示您的性格，气质，喜好类型，让其他人更了解您',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 20),
                  buildTagsSection('我是', iamTags),
                  const SizedBox(height: 20),
                  buildTagsSection('我喜欢', ilikeTags),
                  const SizedBox(height: 20),
                  buildTagsSection('我拒绝', irefuseTags),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (validateSelections()) {
                // 如果校验通过，执行跳转和调用接口
                Map<String, List<String>> tags = {
                  "personalities": iamTags.where((tag) => selectedTags[tag] == true).toList(),
                  "iLikes": ilikeTags.where((tag) => selectedTags[tag] == true).toList(),
                  "iRefuses": irefuseTags.where((tag) => selectedTags[tag] == true).toList(),
                };
                var response = await ApiService().post("/mine/tags", tags);
                if (response.statusCode == 200) {
                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) => SocialTrendPage(),
                    ),
                  );
                }
              } else {
                showToast('每个选项选择数量必须在1到5个之间',
                    duration: const Duration(seconds: 2),
                    position: ToastPosition.bottom,
                    backgroundColor: Colors.black12,
                    textPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    textStyle: const TextStyle(color: Colors.black));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent, // 按钮背景色
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // 圆角
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0), // 垂直填充
              elevation: 0,
            ),
            child: const Text(
              "下一步",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
        ));
  }
}
