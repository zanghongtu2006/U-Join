import 'package:flutter/material.dart';

import '../chat_page/contact_list.dart';

class SocialStatusTabView extends StatefulWidget {
  int fansCount = 0;
  int focusCount = 0;
  int visitorsCount = 0;

  SocialStatusTabView(
      {Key? key,
        required this.fansCount,
        required this.focusCount,
        required this.visitorsCount
      })
      : super(key: key);

  @override
  _SocialStatusTabViewState createState() => _SocialStatusTabViewState();
}

class _SocialStatusTabViewState extends State<SocialStatusTabView> {
  // 当前选中的索引

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // 构建类似于Tab的结构
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: _buildTabItem(0, '粉丝', widget.fansCount)),
              _buildVerticalDivider(),
              Expanded(child: _buildTabItem(1, '关注', widget.focusCount)),
              _buildVerticalDivider(),
              Expanded(child: _buildTabItem(2, '访客', widget.visitorsCount)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem(int index, String title, int number) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ContactListPage(filter: title),
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center, // 确保文本居中
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 使 Row 内的子项居中
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(width: 2),
            Text(
              number.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return const SizedBox(
      height: 20,
      child: VerticalDivider(color: Colors.grey),
    );
  }
}
