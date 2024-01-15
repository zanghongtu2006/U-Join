import 'package:flutter/material.dart';

import '../../util/web_page.dart';

class PrivacyBeforeLoginWidget extends StatefulWidget {
  const PrivacyBeforeLoginWidget({super.key});

  @override
  _PrivacyBeforeLoginWidget createState() => _PrivacyBeforeLoginWidget();
}

class _PrivacyBeforeLoginWidget extends State<PrivacyBeforeLoginWidget> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 添加这行来居中对齐子控件
      children: <Widget>[
        // 单选按钮
        Radio<bool>(
          value: true,
          groupValue: agreed,
          onChanged: (bool? value) {
            setState(() {
              agreed = !agreed;
            });
          },
        ),
        // 文本和链接
        const Text(
          '阅读并同意 ',
          style: TextStyle(color: Colors.black),
        ),
        InkWell(
          onTap: () {
            _openWebPage(context, 'https://example.com/user-agreement');
          },
          child: const Text(
            '【用户协议】',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const Text(
          ' 和 ',
          style: TextStyle(color: Colors.black),
        ),
        InkWell(
          onTap: () {
            _openWebPage(context, 'https://example.com/privacy-policy');
          },
          child: const Text(
            '【隐私政策】',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  void _openWebPage(BuildContext context, String url) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WebPage(url: url)));
  }
}
