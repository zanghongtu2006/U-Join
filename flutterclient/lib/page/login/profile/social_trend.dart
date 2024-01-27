import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterclient/main.dart';

import '../../../util/date_picker.dart';
import '../../../util/number_picker.dart';
import 'progress.dart';

class SocialTrendPage extends StatefulWidget {
  @override
  _SocialTrendPageState createState() => _SocialTrendPageState();
}

class _SocialTrendPageState extends State<SocialTrendPage> {
  // 假设您已经从图像中提取了所有的标签文本
  final List<String> sexual = ['小哥哥', '小姐姐', '都可以', '保密'];
  final List<String> relationType = ['网恋', '找人陪伴', '恋爱奔现', '处CP'];
  // 标签选中状态
  Map<String, bool> selectedTags = {};

  @override
  void initState() {
    super.initState();
    // 初始化标签选中状态为false
    for (var tag in [...sexual, ...relationType]) {
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
                const Text('选择您的交友属性，增加陪陪的精准度，快速契合适合您的灵魂，如果没有或者不想透露，可以选择”无“、”跳过“、”保密“或不填',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 20),
                buildTagsSection('性别取向', sexual),
                const SizedBox(height: 20),
                buildTagsSection('寻求关系', relationType),
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
                builder: (context) => HomeScreen(),
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
          child: const Text("完成", style: TextStyle(fontSize: 16.0, color: Colors.white),),
        ),
      )
    );
  }
}
