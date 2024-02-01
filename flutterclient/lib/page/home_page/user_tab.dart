import 'package:flutter/material.dart';
import 'package:flutterclient/page/chat_page/chat.dart';

import '../button/logo_button.dart';

class UsersTabView extends StatelessWidget {
  const UsersTabView({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          for (int index = 0; index < 10; index++)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // 设置边框圆角
                side: const BorderSide(
                    color: Colors.lightBlue, width: 0.2), // 设置边框颜色和宽度
              ),
              elevation: 0,
              margin: const EdgeInsets.all(10), // 设置卡片之间的间距
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                         CircleAvatar(
                          backgroundImage: index==0 ? AssetImage('assets/login_qq_icon.png'):
                              AssetImage('assets/girls_voice/girl_voice_$index.png'),
                          radius: 32, // 头像的大小
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('用户名 $index',
                                style: const TextStyle(fontSize: 16)),
                            // 用户名靠近上边缘
                            const Text('性别 - 160cm - 其它'),
                          ],
                        ), // 添加 Spacer 来填充剩余空间
                      ],
                    ),
                    const SizedBox(height: 8), // 添加间距
                    Row(
                      children: <Widget>[
                        const SizedBox(width: 4),
                        Text(
                          '标签 $index, 标签 ${index + 1}',
                          style: const TextStyle(color: Colors.orange), // 橙色字体
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/icon/location.png',
                              height: 16, // 图标的高度
                              width: 16, // 图标的宽度
                            ),
                            const SizedBox(width: 8), // 图标与文本之间的间距
                            Text('地点 $index',
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const Spacer(),
                        LogoButton(
                          logoPath: 'assets/icon/love_chat_icon.png',
                          borderColor: Colors.lightBlue,
                          text: '搭讪',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(userId: "hello",nickName: 'hello',avatar: "avatar",)), // TargetPage是要跳转到的页面
                            );
                          },
                        ),
                        const SizedBox(width: 8)
                      ],
                    ),
                    const SizedBox(height: 8)// 地点
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
