import 'package:flutter/material.dart';

import 'chat_item.dart';

class ChatListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (context, index) => ChatListItem(),
      separatorBuilder: (context, index) {
        // 如果索引为奇数，则不添加置顶说明文本
        if (index > 1) {
          return Divider(
            color: Colors.grey[300], // 浅灰色分割线
            height: 1, // 分割线的高度
          );
        }
        // 对于索引为偶数的项，在分割线右下方添加文本
        return Column(
          children: [
            Divider(
              color: Colors.grey[300],
              height: 1,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icon/img_perfect_cursor.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                      top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
                  child: Text(
                    '置顶',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
