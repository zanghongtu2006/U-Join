import 'package:flutter/material.dart';
import 'package:flutterclient/page/mine_page/social_status.dart';

import 'common_function.dart';
import 'task_center.dart';
import 'user_info.dart';
import 'wallet_store_button.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mine/bg_color.png'), // 图片路径
            fit: BoxFit.cover, // 填充模式
          ),
        ),
        child: ListView(
          children: <Widget>[
            UserInformationSection(),
            SocialStatusTabView(),
            WalletAndStoreButtons(),
            const TaskCenterSection(),
            CommonFunctionsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(int index, String title) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue, backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent, // 去除阴影效果
        elevation: 0, // 去除立体效果
      ),
      child: Text(title),
    );
  }

  Widget _buildVerticalDivider() {
    return const SizedBox(
      height: 20,
      child: VerticalDivider(color: Colors.grey),
    );
  }
}
