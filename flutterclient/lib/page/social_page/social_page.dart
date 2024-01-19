import 'package:flutter/material.dart';
import 'filter_button.dart';
import 'post_card.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  int _selectedFilterIndex = 0; // 当前选中的筛选条件索引
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          FilterButtons(
            // 使用 FilterButtons 组件
            onSelected: (index) {
              setState(() {
                _selectedFilterIndex = index;
                // 根据不同的筛选条件触发不同的操作
                switch (index) {
                  case 0:
                    // 处理发现筛选条件
                    break;
                  case 1:
                    // 处理最新筛选条件
                    break;
                  case 2:
                    // 处理声控筛选条件
                    break;
                  case 3:
                    // 处理关注筛选条件
                    break;
                  default:
                    break;
                }
              });
            },
            onFilter: () {
              // 处理筛选按钮点击事件
              // 可以弹出筛选条件的底部弹窗或执行其他操作
            },
          ),
          Expanded(
            child: ListView(
              children: const <Widget>[
                PostCard(
                  avatar: 'assets/girls_voice/girl_voice_3.png',
                  name: '不太疼的小可爱',
                  age: 29,
                  height: 163,
                  content: '今天是幸运的一天💕💕',
                  images: [
                    'assets/5a7d1b74110aca2abac1836aec48a06.jpg',
                  ],
                  location: '成都QC',
                ),
                PostCard(
                  avatar: 'assets/girls_voice/girl_voice_1.png',
                  name: '不太疼的小可爱',
                  age: 29,
                  height: 163,
                  content: '今天是幸运的一天💕💕',
                  images: [
                    'assets/5a7d1b74110aca2abac1836aec48a06.jpg',
                    'assets/5a7d1b74110aca2abac1836aec48a06.jpg',
                  ],
                  location: '成都QC',
                ),
                PostCard(
                  avatar: 'assets/girls_voice/girl_voice_2.png',
                  name: '不太疼的小可爱',
                  age: 29,
                  height: 163,
                  content: '今天是幸运的一天💕💕',
                  images: [
                    'assets/girls_voice/girl_voice_2.png',
                    'assets/girls_voice/girl_voice_3.png',
                    'assets/girls_voice/girl_voice_4.png'
                  ],
                  location: '成都QC',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
