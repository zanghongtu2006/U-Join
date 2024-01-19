import 'package:flutter/material.dart';

class LogoButton extends StatelessWidget {
  final String logoPath;
  final String text;
  final VoidCallback onPressed; // 添加一个回调函数属性
  final double borderWidth; // 边框宽度
  final Color borderColor; // 边框颜色
  final Color backgroundColor;
  final Color textColor;

  LogoButton({
    required this.logoPath,
    required this.text,
    required this.onPressed, // 需要在构造函数中传入
    this.borderWidth = 0.0, // 默认边框宽度为0.0
    this.borderColor = Colors.transparent, // 默认边框颜色为黑色
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // 使用传入的回调函数
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: borderWidth, // 使用传入的边框宽度
            color: borderColor, // 使用传入的边框颜色
          ),
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
            Text(text, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}
