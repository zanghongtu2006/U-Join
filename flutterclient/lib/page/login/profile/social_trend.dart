import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterclient/main.dart';
import 'package:oktoast/oktoast.dart';

import '../../../util/api_service.dart';
import 'progress.dart';

class SocialTrendPage extends StatefulWidget {
  @override
  _SocialTrendPageState createState() => _SocialTrendPageState();
}

class _SocialTrendPageState extends State<SocialTrendPage> {
  // 假设您已经从图像中提取了所有的标签文本
  // late List<String> sexual = ['保密', '都可以', '小哥哥', '小姐姐'];
  // late List<String> relationType = ['网恋奔现', '网恋', '找人陪伴', '处cp'];
  // late Map<String, String> sexualCodeMap = {'保密': 'SECRET', '都可以': 'BOTH', '小哥哥': 'MALE', '小姐姐': 'FEMALE'};
  // late Map<String, String> relationTypeCodeMap = {'找人陪伴': 'ACCOMPANY', '网恋奔现': 'LOVETOREAL',' 网恋': 'LOVE', '处cp': 'CP'};
  late List<String> sexual = [];
  late List<String> relationType = [];
  late Map<String, String> sexualCodeMap = {};
  late Map<String, String> relationTypeCodeMap = {};

  // 标签选中状态
  Map<String, bool> selectedTags = {};

  @override
  void initState() {
    super.initState();
    _fetchTags();
    // 初始化标签选中状态为false
    for (var tag in [...sexual, ...relationType]) {
      selectedTags[tag] = false;
    }
  }

  Future<void> _fetchTags() async {
    final Map<String, String> params = {'code': 'SEXUAL,RELATION_TYPE'};
    var response = await ApiService().get("/dicts/items", params: params);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      print(json.decode(response.body));
      // 处理SEXUAL数据
      List<Map<String, dynamic>> sexualData =
          List<Map<String, dynamic>>.from(data['SEXUAL']);
      List<String> newSexual = [];
      Map<String, String> newSexualCodeMap = {};

      for (var item in sexualData) {
        newSexual.add(item['dictItemName']);
        newSexualCodeMap[item['dictItemName']] = item['dictItemCode'];
      }
      print(newSexualCodeMap);

      // 处理RELATION_TYPE数据
      List<Map<String, dynamic>> relationTypeData =
          List<Map<String, dynamic>>.from(data['RELATION_TYPE']);
      List<String> newRelationType = [];
      Map<String, String> newRelationTypeCodeMap = {};

      for (var item in relationTypeData) {
        newRelationType.add(item['dictItemName']);
        newRelationTypeCodeMap[item['dictItemName']] = item['dictItemCode'];
      }

      // 更新状态
      setState(() {
        sexual = newSexual;
        relationType = newRelationType;
        sexualCodeMap = newSexualCodeMap;
        relationTypeCodeMap = newRelationTypeCodeMap;
      });
    }
  }

  Widget buildTagsSection(String title, List<String> tags, String tagGroup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: tags.map((tag) {
            return ChoiceChip(
              label: Text(tag),
              labelStyle: TextStyle(
                color: selectedTags[tag] ?? false ? Colors.white : Colors.black,
              ),
              selected: selectedTags[tag] ?? false,
              selectedColor: Colors.indigoAccent,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    // 如果选中了一个标签，则取消同一组中其他标签的选中状态
                    for (var otherTag in tags) {
                      if (otherTag != tag) {
                        selectedTags[otherTag] = false;
                      }
                    }
                  }
                  selectedTags[tag] = selected;
                });
              },
              backgroundColor: Colors.transparent,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  bool validateSelections() {
    return sexual.where((tag) => selectedTags[tag] == true).length == 1 &&
        relationType.where((tag) => selectedTags[tag] == true).length == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mine/bg_color.png'), // 图片路径
            fit: BoxFit.fill, // 填充模式
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
                    currentStep: 4,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('您的交友属性',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                    '选择您的交友属性，增加陪陪的精准度，快速契合适合您的灵魂，如果没有或者不想透露，可以选择”无“、”跳过“、”保密“或不填',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 20),
                buildTagsSection('性别取向', sexual, 'sexual'),
                const SizedBox(height: 20),
                buildTagsSection('寻求关系', relationType, 'relationType'),
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
              Map<String, String?> tags = {
                "sexual": sexualCodeMap[
                    sexual.where((tag) => selectedTags[tag] == true).first],
                "relationType": relationTypeCodeMap[relationType
                    .where((tag) => selectedTags[tag] == true)
                    .first],
              };
              var response = await ApiService().post("/mine/tags", tags);
              if (response.statusCode == 200) {
                navigator.push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              }
            } else {
              showToast('请选择性别取向和寻求关系类型',
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
            "完成",
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
