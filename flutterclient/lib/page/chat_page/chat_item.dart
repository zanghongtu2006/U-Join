import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 假设的数据
    String avatarUrl = 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F9e18d14b-8a44-41b0-97d9-6aed05b70e7f%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1708239669&t=7419a9b0c446be680b50cf09098fe810';
    String userName = '用户名';
    String lastMessage = '最近一条聊天记录';
    bool isOnline = true; // 根据实际情况设定

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
              Text(userName),
              const SizedBox(width: 4),
              Image.asset('assets/icon/icon_woman.png', width: 12)
            ],
          ),
          const Spacer(),
          const Text('2024-01-13 14:28',style: TextStyle(color: Colors.grey, fontSize: 10))
        ],
      ),
      subtitle: Text(lastMessage, style: TextStyle(color: Colors.grey,fontSize: 14)),
      // 可以在这里添加一个时间戳或其他的标记
    );
  }
}
