import 'package:flutter/material.dart';

class SocialStatusTabView extends StatefulWidget {
  @override
  _SocialStatusTabViewState createState() => _SocialStatusTabViewState();
}

class _SocialStatusTabViewState extends State<SocialStatusTabView> {
  int _currentIndex = 0; // 当前选中的索引

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // 构建类似于Tab的结构
        Padding(
          padding: EdgeInsets.only(left: 32, right: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: _buildTabItem(0, '粉丝', 62)),
              _buildVerticalDivider(),
              Expanded(child: _buildTabItem(1, '关注', 80)),
              _buildVerticalDivider(),
              Expanded(child: _buildTabItem(2, '访客', 300)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem(int index, String title, int number) {
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center, // 确保文本居中
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 使 Row 内的子项居中
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(width: 2),
            Text(
              number.toString(),
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 20,
      child: VerticalDivider(color: Colors.grey),
    );
  }
}
