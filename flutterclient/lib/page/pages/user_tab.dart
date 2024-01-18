import 'package:flutter/material.dart';

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
              margin: const EdgeInsets.all(8), // 设置卡片之间的间距
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/login_qq_icon.png'),
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
                    Text(
                      '标签 $index, 标签 ${index + 1}',
                      style: const TextStyle(color: Colors.orange), // 橙色字体
                    ),
                    Row(
                      children: <Widget>[
                        Text('地点 $index'),
                        Spacer(),
                        IconButton(
                          icon: const Icon(Icons.message),
                          onPressed: () {
                            // 消息页面逻辑
                          },
                        ),
                      ],
                    ), // 地点
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
