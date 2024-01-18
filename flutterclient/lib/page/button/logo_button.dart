import 'package:flutter/material.dart';

class LogoButton extends StatelessWidget {
  final String logoPath;
  final String text;
  final VoidCallback onPressed; // 添加一个回调函数属性

  LogoButton({
    required this.logoPath,
    required this.text,
    required this.onPressed, // 需要在构造函数中传入
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // 使用传入的回调函数
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              logoPath,
              width: 22, // 控制图片宽度
              height: 22, // 控制图片高度
              fit: BoxFit.cover, // 控制图片的填充方式
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
