import 'package:flutter/material.dart';

import 'conversation_page/conversation_list.dart';
import 'contact_page/contact_list_navigate.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late int _selectedIndex = 0; // 当前选中的索引

  final List<Widget> _pages = [
    ChatListWidget(), // 消息列表Widget
    ContactListNavigateWidget(), // 通讯录列表Widget
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            // 从顶部开始
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.20,
            // 设置高度为屏幕高度的20%
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg_top.png"),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(width: 8),
                    // 消息按钮
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedIndex = 0);
                      },
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0), // 减少按钮内边距
                          minimumSize: const Size(0, 0)
                      ),
                      child: Text(
                        '消息',
                        style: TextStyle(
                            color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                            fontSize: 16
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // 按钮之间的间距
                    // 通讯录按钮
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedIndex = 1);
                      },
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0), // 减少按钮内边距
                          minimumSize: const Size(0, 0)
                      ),
                      child: Text(
                        '通讯录',
                        style: TextStyle(
                            color: _selectedIndex == 1 ? Colors.blue : Colors.black,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ), // 显示选中的页面
              ),
            ],
          )
        ],
      ),
    );
  }
}