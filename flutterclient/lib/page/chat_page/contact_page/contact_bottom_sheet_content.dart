import 'package:flutter/material.dart';

class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          _buildButton(
            context: context,
            text: '取消关注',
            icon: Icons.person_outline,
            onPressed: () {
              // 处理取消关注逻辑
              Navigator.pop(context); // 关闭模态框
            },
          ),
          _buildButton(
            context: context,
            text: '私聊',
            icon: Icons.chat,
            onPressed: () {
              // 处理私聊逻辑
              Navigator.pop(context); // 关闭模态框
            },
          ),
          _buildButton(
            context: context,
            text: '举报',
            icon: Icons.report,
            onPressed: () {
              // 处理举报逻辑
              Navigator.pop(context); // 关闭模态框
            },
          ),
          _buildButton(
            context: context,
            text: '取消',
            icon: Icons.cancel,
            onPressed: () {
              Navigator.pop(context); // 关闭模态框
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: text != '取消' ? Colors.grey[300] : Colors.transparent,
          minimumSize: const Size.fromHeight(48), // 按钮高度
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 圆角
          ),
        ),
        onPressed: onPressed,
        child: Align(
          alignment: Alignment.center,
          child: Text(text, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
