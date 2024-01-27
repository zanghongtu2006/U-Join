import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterclient/page/mine_page/social_status.dart';
import 'package:flutterclient/util/api_service.dart';

import 'common_function.dart';
import 'task_center.dart';
import 'user_info.dart';
import 'wallet_store_button.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String id = "";
  String nickname = '';
  String avatar = '';
  String gender = "";
  int level = 0;
  List<int> receivedStatus = [];
  int fansCount = 0;
  int focusCount = 0;
  int visitorsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchMineData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchMineData() async {
    try {
      var response = await ApiService().get("/mine");
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        print(data);
        setState(() {
          id = data['id'] ?? ''; // 确保数据中有 'id' 字段
          nickname = data['nickname'] ?? '';
          avatar = data['avatar'] ?? '';
          level = data['level'] ?? ''; // 确保数据中有 'level' 字段，并且它是一个整数
          receivedStatus = List<int>.from(data['taskStatus']);

          fansCount = data['fansCount'] ?? 0;
          focusCount = data['focusCount'] ?? 0;
          visitorsCount = data['visitorsCount'] ?? 0;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchMineData,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mine/bg_color.png'), // 图片路径
              fit: BoxFit.cover, // 填充模式
            ),
          ),
          child: ListView(
            children: <Widget>[
              UserInformationSection(
                  id: id, nickname: nickname, avatar: avatar, level: level),
              SocialStatusTabView(fansCount:fansCount,focusCount:focusCount,visitorsCount:visitorsCount),
              WalletAndStoreButtons(),
              const TaskCenterSection(),
              const CommonFunctionsGrid(),
            ],
          ),
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
