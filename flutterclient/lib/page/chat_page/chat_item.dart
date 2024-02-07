import 'package:flutter/material.dart';

import 'chat.dart';

class ChatListItem extends StatelessWidget {

  final String conversationId;
  final String avatarUrl;
  final String nickName;
  final String lastMessage;
  final bool isOnline;

  ChatListItem({
    required this.conversationId,
    required this.avatarUrl,
    required this.nickName,
    required this.lastMessage, // 需要在构造函数中传入
    required this.isOnline, // 需要在构造函数中传入
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
          Positioned(
            // 在线状态的小红点
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
            ),
          ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min, // 限制Row的大小只包含子部件所需的大小
            children: [
              Text(nickName),
              const SizedBox(width: 4),
              Image.asset('assets/icon/yhc_nv.png', width: 10)
            ],
          ),
          const Spacer(),
          const Text('2024-01-13 14:28',style: TextStyle(color: Colors.grey, fontSize: 10))
        ],
      ),
      subtitle: Text(lastMessage, style: TextStyle(color: Colors.grey,fontSize: 14)),
      onTap: () {
        // 在这里添加跳转逻辑
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(conversationId: conversationId, avatar: avatarUrl, nickName:nickName),
          ),
        );
      },
    );
  }
}
