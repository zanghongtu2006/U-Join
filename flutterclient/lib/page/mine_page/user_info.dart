import 'package:flutter/material.dart';

// 个人信息部分
class UserInformationSection extends StatefulWidget {
  final String id;
  final String nickname;
  final String avatar;
  final int level;

  const UserInformationSection(
      {Key? key,
        required this.id,
        required this.nickname,
        required this.avatar,
        required this.level})
      : super(key: key);

  @override
  _UserInformationSectionState createState() => _UserInformationSectionState();
}
class _UserInformationSectionState extends State<UserInformationSection> {
  @override
  Widget build(BuildContext context) {
    print("avatar");
    print(widget.avatar);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: widget.avatar.isNotEmpty
                ? NetworkImage(widget.avatar)
                : const AssetImage("assets/login_qq_icon.png") as ImageProvider,
            // 示例图片地址
            radius: 26,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(widget.nickname, style: const TextStyle(fontSize: 16))
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Image.asset('assets/mine/icon_id.png', height: 12),
                    SizedBox(width: 4),
                    Text(widget.id,
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
