import 'package:flutter/material.dart';
import 'package:flutterclient/page/social_page/social_page.dart';

import '../util/ws_service.dart';
import 'chat_page/chat_page.dart';
import 'home_page/home_page.dart';
import 'mine_page/mine_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  // 底部导航栏中的各个页面
  final List<Widget> _pages = [
    const HomePage(),
    SocialPage(),
    SocialPage(),
    const ChatListPage(),
    const MinePage(),
  ];

  @override
  void initState() {
    super.initState();
    ChatService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ), // 使用IndexedStack来保持页面状态
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          // 当点击不同的项时，更新当前索引
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _currentIndex == 0
                ? Image.asset(
                    'assets/icon/home_2.png',
                    width: 24,
                  ) // 当选中时显示的图片
                : Image.asset(
                    'assets/icon/home.png',
                    width: 24,
                  ), // 未选中时显示的图片
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? Image.asset(
                    'assets/icon/discover_2.png',
                    width: 24,
                  ) // 当选中时显示的图片
                : Image.asset(
                    'assets/icon/discover.png',
                    width: 24,
                  ),
            label: '发现',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '交友',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 3
                ? Image.asset(
                    'assets/icon/chat_2.png',
                    width: 24,
                  ) // 当选中时显示的图片
                : Image.asset(
                    'assets/icon/chat.png',
                    width: 24,
                  ),
            label: '消息',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 4
                ? Image.asset(
                    'assets/icon/person_2.png',
                    width: 24,
                  ) // 当选中时显示的图片
                : Image.asset(
                    'assets/icon/person.png',
                    width: 24,
                  ),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
