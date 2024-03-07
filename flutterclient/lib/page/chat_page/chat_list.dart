import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../util/data_cache.dart';
import 'chat_item.dart';
import 'model/conversation_model.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({super.key});

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> with WidgetsBindingObserver {
  List<dynamic> contacts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchContacts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 处理应用生命周期状态变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 当应用或页面重新获得焦点时，刷新聊天列表
      _fetchContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchContacts,
      child: ListView.separated(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          var contact = contacts[index];
          return Slidable(
            key: ValueKey(contact.conversationId), // 确保每个 Slidable 有唯一的 key
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.16, // 定义滑动动画效果
              children: [
                SlidableAction(
                  onPressed: (context) => _deleteContact(contact),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: '删除',
                  autoClose: true,
                ),
              ],
            ),
            child: ChatListItem(
              conversationId: contact.conversationId,
              shortConversationId: contact.shortConversationId,
              avatarUrl: contact.avatar,
              nickName: contact.nickName,
              userIds: contact.userIds,
              lastMessage: contact.lastMessage,
              lastUpdateTime: contact.lastUpdateTime,
              isOnline: true,
              onChatClosed: () {
                _fetchContacts(); // 当从聊天页面返回时调用
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          if (index > 1) {
            return Divider(
              color: Colors.grey[300], // 浅灰色分割线
              height: 1, // 分割线的高度
            );
          }
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
      ),
    );
  }

  Future<void> _fetchContacts() async {
    print("=========_fetchContacts");
    try {
      List<Conversation> conversations = await DataCache().fetchConversations(1, 20);
      setState(() {
        contacts.clear();
        contacts.addAll(conversations);
      });
    } catch( e) {
      print(e);
    }
  }

  void _deleteContact(contact) {
    setState(() {
      contacts.remove(contact);
    });
  }
}
