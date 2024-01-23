import 'package:flutter/material.dart';

// 钱包和商城按钮
class WalletAndStoreButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(24,8,24,8), // 添加适当的外边距
      decoration: BoxDecoration(
        color: Colors.white, // 按钮的背景颜色
        borderRadius: BorderRadius.circular(8), // 边角圆润
        boxShadow: [ // 阴影效果
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                // 钱包按钮点击事件
              },
              child: ListTile(
                leading: Stack(
                  children: <Widget>[
                    Image.asset('assets/mine/wallet.png', width: 32),
                  ],
                ),
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min, // 限制Row的大小只包含子部件所需的大小
                      children: [
                        Text('我的钱包', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                        SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
                subtitle: Text('撩币、积分、恋爱豆', style: TextStyle(color: Colors.grey,fontSize: 10)),
                // 可以在这里添加一个时间戳或其他的标记
              ),
            ),
          ),
          Container(
            height: 20, // 分割线的高度
            width: 1, // 分割线的宽度
            color: Colors.grey, // 分割线的颜色
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                // 钱包按钮点击事件
              },
              child: ListTile(
                leading: Stack(
                  children: <Widget>[
                    Image.asset('assets/mine/shop.png', width: 32),
                  ],
                ),
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min, // 限制Row的大小只包含子部件所需的大小
                      children: [
                        Text('商城', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                        SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
                subtitle: Text('姻缘卡、头像框', style: TextStyle(color: Colors.grey,fontSize: 10)),
                // 可以在这里添加一个时间戳或其他的标记
              ),
            ),
          ),
        ],
      ),
    );
  }
}
