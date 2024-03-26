import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterclient/util/db_manager.dart';

import '../../../util/data_cache.dart';
import 'conversation_item.dart';
import '../model/conversation_model.dart';

class ConversationListWidget extends StatefulWidget {
  const ConversationListWidget({super.key});

  @override
  _ConversationListWidgetState createState() => _ConversationListWidgetState();
}

class _ConversationListWidgetState extends State<ConversationListWidget> with WidgetsBindingObserver {
  List<Conversation> conversations = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchConversations();
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
      _fetchConversations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchConversations,
      child: ListView.separated(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          Conversation conversation = conversations[index];
          return Slidable(
            key: ValueKey(conversation.conversationId), // 确保每个 Slidable 有唯一的 key
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.16, // 定义滑动动画效果
              children: [
                SlidableAction(
                  onPressed: (context) => _deleteContact(conversation),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: '删除',
                  autoClose: true,
                ),
              ],
            ),
            child: ConversationItem(
              conversationId: conversation.conversationId,
              shortConversationId: conversation.shortConversationId,
              avatarUrl: conversation.avatar,
              nickName: conversation.nickName,
              userIds: conversation.userIds,
              lastMessage: conversation.lastMessage,
              lastUpdateTime: conversation.lastUpdateTime,
              isOnline: true,
              onChatClosed: () {
                _fetchConversations(); // 当从聊天页面返回时调用
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

  Future<void> _fetchConversations() async {
    try {
      List<Conversation> list = await DataCache().fetchConversations(1, 20);
      setState(() {
        conversations.clear();
        conversations.addAll(list);
      });
    } catch( e) {
      print(e);
    }
  }

  void _deleteContact(Conversation conversation) {
    setState(() {
      conversations.remove(conversation);
    });
    DatabaseManager.instance.deleteConversation(conversation.conversationId);
  }
}
