import 'package:flutter/material.dart';

import 'filter_button.dart';
import 'user_tab.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start, // 尝试调整这里
        children: <Widget>[
          FilterButtons(
            onSelected: (index) {
              // 处理文本按钮的点击事件
              print('选中了: ${index}');
            },
            onFilter: () {
              // 处理筛选图标按钮的点击事件
              print('点击了筛选按钮');
            },
          ), // 使用自定义的筛选按钮组件
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                UsersTabView(),
                UsersTabView(),
                UsersTabView(),
                UsersTabView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
