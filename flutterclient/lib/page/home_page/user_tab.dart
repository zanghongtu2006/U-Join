import 'package:flutter/material.dart';
import 'package:flutterclient/page/chat_page/chat/chat.dart';
import 'package:flutterclient/page/chat_page/model/conversation_model.dart';
import 'package:flutterclient/util/chat_util.dart';
import 'package:flutterclient/util/db_manager.dart';

import '../../util/api_service.dart';
import '../button/logo_button.dart';
import '../chat_page/model/user_model.dart';

class UserTabView extends StatefulWidget {
  final User user;

  const UserTabView({super.key, required this.user});

  @override
  _UserTabViewState createState() => _UserTabViewState();
}

class _UserTabViewState extends State<UserTabView> {
  late String gender = '女';
  late String title = 'gender - 160cm - 其它';
  late String _myUid;
  late String conversationId;
  late String shortConversationId;
  late List<String> userIds = [];

  @override
  void initState() {
    switch (widget.user.gender) {
      case 'FEMAIL':
        gender = '女';
        break;
      case 'MAIL':
        gender = '男';
        break;
      default:
        gender = '未知';
        break;
    }
    title = '$gender - ${widget.user.height} - 其它';
    _initIds();
  }

  Future<void> _initIds() async {
    _myUid = await ApiService().getUid();
    userIds = [widget.user.id, _myUid];
    conversationId = ChatUtils.generateConversationId(userIds);
    shortConversationId = conversationId.substring(0, 8) + conversationId.substring(36, 44);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // 设置边框圆角
        side:
            const BorderSide(color: Colors.lightBlue, width: 0.2), // 设置边框颜色和宽度
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
                  backgroundImage: NetworkImage(widget.user.avatar),
                  radius: 32, // 头像的大小
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.user.nickName,
                        style: const TextStyle(fontSize: 16)),
                    // 用户名靠近上边缘
                    Text(title),
                  ],
                ), // 添加 Spacer 来填充剩余空间
              ],
            ),
            const SizedBox(height: 8), // 添加间距
            const Row(
              children: <Widget>[
                SizedBox(width: 4),
                Text(
                  '标签 1, 标签 ${1 + 1}',
                  style: TextStyle(color: Colors.orange), // 橙色字体
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
                    const Text('地点 1', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                LogoButton(
                  logoPath: 'assets/icon/love_chat_icon.png',
                  borderColor: Colors.lightBlue,
                  text: '搭讪',
                  onPressed: () {
                    Conversation conversation = Conversation(
                      conversationId: conversationId,
                      shortConversationId: shortConversationId,
                      nickName: widget.user.nickName,
                      type: 'PERSON',
                      avatar: widget.user.avatar,
                      lastMessage: '',
                      userIds: userIds,
                      unReadCount: 0,
                      gender: widget.user.gender,
                      lastUpdateTime: DateTime.now());
                      DatabaseManager.instance
                          .insertOrUpdateConversation(conversation);
                      ApiService().post("/conversations", conversation.toJson());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            userIds: [widget.user.id, _myUid],
                            conversationId: conversationId,
                            shortConversationId: shortConversationId,
                            nickName: widget.user.nickName,
                            avatar: widget.user.avatar,
                          ),
                        ), // TargetPage是要跳转到的页面
                      );
                    },
                ),
                const SizedBox(width: 8)
              ],
            ),
            const SizedBox(height: 8) // 地点
          ],
        ),
      ),
    );
  }
}
