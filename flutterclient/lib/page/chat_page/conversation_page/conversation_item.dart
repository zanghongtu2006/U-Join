import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../chat/chat.dart';

class ConversationItem extends StatefulWidget {
  final String conversationId;
  final String shortConversationId;
  final String avatarUrl;
  final String nickName;
  final String lastMessage;
  final DateTime lastUpdateTime;
  final List<String> userIds;
  final bool isOnline;
  final Function onChatClosed;

  const ConversationItem({
    super.key,
    required this.conversationId,
    required this.shortConversationId,
    required this.avatarUrl,
    required this.nickName,
    required this.userIds,
    required this.lastUpdateTime,
    required this.lastMessage, // 需要在构造函数中传入
    required this.isOnline, // 需要在构造函数中传入
    required this.onChatClosed
  });

  @override
  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(widget.avatarUrl),
          ),
          Positioned(
            // 在线状态的小红点
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: widget.isOnline ? Colors.green : Colors.grey,
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
              Text(widget.nickName),
              const SizedBox(width: 4),
              Image.asset('assets/icon/yhc_nv.png', width: 10)
            ],
          ),
          const Spacer(),
          Text(DateFormat('yyyy-MM-dd HH:mm').format(widget.lastUpdateTime),style: const TextStyle(color: Colors.grey, fontSize: 10))
        ],
      ),
      subtitle: Text(widget.lastMessage, style: const TextStyle(color: Colors.grey,fontSize: 14)),
      onTap: () {
        // 在这里添加跳转逻辑
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(conversationId: widget.conversationId,userIds:widget.userIds,
                shortConversationId: widget.shortConversationId,avatar: widget.avatarUrl, nickName:widget.nickName),
          )
        ).then((value) => {widget.onChatClosed.call()});
      },
    );
  }
}
