import 'package:flutter/material.dart';

import 'contact_list.dart';


class ContactListNavigateWidget extends StatefulWidget {
  const ContactListNavigateWidget({super.key});

  @override
  _ContactListNavigateWidgetState createState() => _ContactListNavigateWidgetState();
}

class _ContactListNavigateWidgetState extends State<ContactListNavigateWidget> {
  @override
  Widget build(BuildContext context) {
    // 这里返回通讯录视图
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            title: Text('假装情侣'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 带上条件 "假装情侣" 跳转到通讯录列表
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactListPage(filter: '假装情侣'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('CP'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 带上条件 "假装情侣" 跳转到通讯录列表
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactListPage(filter: 'CP'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('粉丝'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 带上条件 "假装情侣" 跳转到通讯录列表
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactListPage(filter: '粉丝'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('关注'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 带上条件 "假装情侣" 跳转到通讯录列表
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactListPage(filter: '关注'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('黑名单'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 带上条件 "假装情侣" 跳转到通讯录列表
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactListPage(filter: '黑名单'),
                ),
              );
            },
          ),
        ],
      ).toList(),
    );
  }
}
