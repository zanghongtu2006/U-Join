import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../../util/api_service.dart';
import '../../login/login_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('系统设置', style: TextStyle(fontSize: 18))),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('隐私设置'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 跳转到隐私设置页面
            },
          ),
          ListTile(
            title: const Text('聊天设置'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 跳转到聊天设置页面
            },
          ),
          ListTile(
            title: const Text('搭讪语'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 跳转到搭讪语设置页面
            },
          ),
          ListTile(
            title: const Text('防骚扰'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 跳转到防骚扰页面
            },
          ),
          ListTile(
            title: const Text('问题反馈'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 跳转到问题反馈页面
            },
          ),
          ListTile(
            title: const Text('关于'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              // 跳转到关于页面
            },
          ),
          ListTile(
            title: const Text('退出登录'),
            trailing: Icon(Icons.chevron_right, color: Colors.black),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认退出登录'),
          content: const Text('您确定要退出登录吗？'),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () async {
                await ApiService().clearToken(); // 清理本地存储的token
                Navigator.of(context).pop(); // 关闭对话框
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
