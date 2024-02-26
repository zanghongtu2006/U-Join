import 'package:flutter/material.dart';
import 'package:flutterclient/page/home_screen.dart';
import 'package:oktoast/oktoast.dart';

class CertificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 这里可以使用TabBar和TabBarView来实现可切换视图
    showToast('正在开发中',
        duration: const Duration(seconds: 2),
        position: ToastPosition.bottom,
        backgroundColor: Colors.black12,
        textPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        textStyle: const TextStyle(color: Colors.black));
    return HomeScreen();
  }
}
