import 'package:flutter/material.dart';

// 假设的聊天模型
class Chat {
  final String avatarUrl;
  final String name;
  final String message;
  final bool isOnline;

  Chat({
    required this.avatarUrl,
    required this.name,
    required this.message,
    required this.isOnline,
  });
}

// 聊天页面
class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // 模拟聊天数据
  final List<Chat> chats = [
    // ... 在这里填充您的模拟数据
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('聊天列表'),
        actions: [
          // 在线状态指示器
          // ... 添加动作和其他控件
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat.avatarUrl),
            ),
            title: Text(chat.name),
            subtitle: Text(chat.message),
            trailing: chat.isOnline
                ? Icon(Icons.circle, color: Colors.green)
                : Icon(Icons.circle, color: Colors.grey),
          );
        },
      ),
    );
  }
}
