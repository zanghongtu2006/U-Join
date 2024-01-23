import 'package:flutter/material.dart';

class TaskCenterSection extends StatelessWidget {
  const TaskCenterSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 假定的领取状态
    final List<bool> receivedStatus = [
      true,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    return Container(
      margin: EdgeInsets.fromLTRB(24, 8, 24, 8), // 添加适当的外边距
      padding: EdgeInsets.fromLTRB(8, 4, 8, 16),
      decoration: BoxDecoration(
        color: Colors.white, // 按钮的背景颜色
        borderRadius: BorderRadius.circular(8), // 边角圆润
        boxShadow: [
          // 阴影效果
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('任务中心',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                InkWell(
                  onTap: () {
                    // 这里放入跳转到任务中心页面的逻辑
                  },
                  child: const Text(
                    '完成任务领取奖励  >',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          // 图标行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              // 根据index选择图标
              String iconPath;
              if (index == 0) {
                iconPath = 'assets/mine/icon_task3.png'; // 第一天已领取
              } else if (index == 1) {
                iconPath = 'assets/mine/icon_task2.png'; // 第二天激活
              } else {
                iconPath = 'assets/mine/icon_task1.png'; // 第三天之后的灰色
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 8),
                  Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    width: 20,
                  ),
                  Text('第${index + 1}天',
                      style: TextStyle(color: Colors.grey, fontSize: 10))
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
