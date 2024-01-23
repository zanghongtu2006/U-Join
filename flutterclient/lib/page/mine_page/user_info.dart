import 'package:flutter/material.dart';

// 个人信息部分
class UserInformationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            backgroundImage: NetworkImage('https://placekitten.com/200/200'),
            // 示例图片地址
            radius: 26,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Row(
                  children: [
                    SizedBox(width: 8),
                    Text('用户名', style: TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    Image.asset('assets/mine/icon_id.png', height: 12),
                    SizedBox(width: 4),
                    const Text('123456',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(width: 4),
                    Image.asset('assets/icon/copy.png', width: 10)
                  ],
                ),
              ],
            ),
          ),
          Text('个人主页   >', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
