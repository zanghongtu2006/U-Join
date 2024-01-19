import 'package:flutter/material.dart';

import 'filter_button.dart';
import 'filter_sheet.dart';
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

  // 添加一个方法来显示底部模态弹窗
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20), // 设置圆角样式
          child: Container(
            color: Colors.white, // 设置背景颜色为白色
            padding: const EdgeInsets.all(16),
            child: FilterSheet(), // 此处是你的 FilterSheet 组件
          ),
        );
      },
    );
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
            onFilter: _showFilterSheet,
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
