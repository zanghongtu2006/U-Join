import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterclient/page/home_page/user_tab.dart';
import 'package:flutterclient/util/api_service.dart';

import '../chat_page/model/user_model.dart';
import 'filter_button.dart';
import 'filter_sheet.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> with SingleTickerProviderStateMixin {
  late List<User> userList = [];
  final ScrollController _scrollController = ScrollController();
  int pageIndex = 1;
  final int pageSize = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserList();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _fetchUserList();
    }
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
              setState(() {
                pageIndex = 1;
                _fetchUserList();
              });
            },
            onFilter: _showFilterSheet,
          ), // 使用自定义的筛选按钮组件
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              controller: _scrollController,
              itemCount: userList.length + 1, // 加1用于在列表底部展示加载更多的指示器
              itemBuilder: (context, index) {
                if (index == userList.length) {
                  // 列表最后一项，展示加载指示器
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }
                User user = userList[index];
                return UserTabView(user: user); // 使用你的UserTabView组件展示用户信息
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<User>> _fetchNewUsers(int pageIndex, int pageSize) async {
    Map<String, dynamic> params = {
      'pageIndex': pageIndex,
      'pageSize': pageSize
    };
    var response = await ApiService().get("/users/users", params: params);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      print("===================$data");
      List<User> users = List<User>.from(data['rows'].map((item) => User.fromMap(item)));
      return users;
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    return [];
  }

  Future<void> _fetchUserList() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    if (!mounted) return;
    List<User> newUsers = await _fetchNewUsers(pageIndex, pageSize);

    setState(() {
      userList.addAll(newUsers);
      pageIndex++; // 准备加载下一页数据
      _isLoading = false;
    });
  }
}
