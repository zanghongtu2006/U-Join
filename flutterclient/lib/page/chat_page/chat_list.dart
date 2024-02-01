import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../util/api_service.dart';
import 'chat_item.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({super.key});

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  List<dynamic> contacts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  @override
  void dispose() {
    super.dispose();
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
            key: ValueKey(contact['id']), // 确保每个 Slidable 有唯一的 key
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
              userId: contact['id'],
              avatarUrl: contact['avatar'],
              nickName: contact['nickName'],
              lastMessage: 'hello',
              isOnline: true,
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
    try {
      var response = await ApiService().get("/users/contacts");
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        print(data);
        setState(() {
          contacts.clear();
          contacts.addAll(data['rows']);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _deleteContact(contact) {
    setState(() {
      contacts.remove(contact);
    });
  }
}
