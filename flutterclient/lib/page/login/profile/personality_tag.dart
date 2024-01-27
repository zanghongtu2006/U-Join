import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterclient/page/login/profile/social_trend.dart';

import '../../../util/date_picker.dart';
import '../../../util/number_picker.dart';
import 'progress.dart';

class PersonalityTagPage extends StatefulWidget {
  @override
  _PersonalityTagPageState createState() => _PersonalityTagPageState();
}

class _PersonalityTagPageState extends State<PersonalityTagPage> {
  // 假设您已经从图像中提取了所有的标签文本
  final List<String> iamTags = ['社交达人', '宅', 'TS', '小萝莉', '宠物控好者', '多重角色', '情感达人'];
  final List<String> ilikeTags = ['文艺', '剧情', '纯爱', '体验感', '二次元', 'Cosplay', '脑洞', 'Pia戏'];
  final List<String> irefuseTags = ['骗虎', '骗吃', 'PUA', '海王', '骗感', '大叔', '小鲜肉', '小骗肉'];
  // 标签选中状态
  Map<String, bool> selectedTags = {};

  @override
  void initState() {
    super.initState();
    // 初始化标签选中状态为false
    for (var tag in [...iamTags, ...ilikeTags, ...irefuseTags]) {
      selectedTags[tag] = false;
    }
  }

  Widget buildTagsSection(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Wrap(
          spacing: 8.0, // 横向间隔
          runSpacing: 4.0, // 纵向间隔
          children: tags.map((tag) => ChoiceChip(
            label: Text(tag),
            labelStyle: TextStyle(
              color: selectedTags[tag] ?? false ? Colors.white : Colors.black, // 根据是否选中改变文字颜色
            ),
            selected: selectedTags[tag] ?? false,
            selectedColor: Colors.indigoAccent, // 选中时的背景颜色
            onSelected: (bool selected) {
              setState(() {
                selectedTags[tag] = selected;
              });
            },
            backgroundColor: Colors.transparent, // 未选中时的背景颜色
            showCheckmark: false, // 不显示对号
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // 设置圆角的大小
            ),
          )).toList(),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SocialTrendPage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent, // 按钮背景色
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // 圆角
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0), // 垂直填充
            elevation: 0,
          ),
          child: const Text("下一步", style: TextStyle(fontSize: 16.0, color: Colors.white),),
        ),
      )
    );
  }
}
