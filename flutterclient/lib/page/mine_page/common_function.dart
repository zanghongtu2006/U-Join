import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'sub_page/certification_page.dart';
import 'sub_page/document_page.dart';
import 'sub_page/favorite_page.dart';
import 'sub_page/invite_page.dart';
import 'sub_page/level_page.dart';
import 'sub_page/member_page.dart';
import 'sub_page/my_circle_page.dart';
import 'sub_page/my_photo_page.dart';
import 'sub_page/security_page.dart';
import 'sub_page/setting_page.dart';
import 'sub_page/teenager_page.dart';

class CommonFunctionsGrid extends StatefulWidget {
  const CommonFunctionsGrid({super.key});

  @override
  _CommonFunctionsGrid createState() => _CommonFunctionsGrid();
}

class _CommonFunctionsGrid extends State<CommonFunctionsGrid> {
  @override
  Widget build(BuildContext context) {
    // 假设每个功能项的数据
    final List<Map<String, dynamic>> functions = [
      {"icon": "assets/mine/member.png", "label": "会员中心", "page": MemberPage()},
      {"icon": "assets/mine/star.png", "label": "我的动态", "page": MyCirclePage()},
      {"icon": "assets/mine/invite.png", "label": "邀请好友", "page": InvitePage()},
      {
        "icon": "assets/mine/favorite.png",
        "label": "亲密羁绊",
        "page": FavoritePage()
      },
      {
        "icon": "assets/mine/certification.png",
        "label": "认证中心",
        "page": CertificationPage()
      },
      {
        "icon": "assets/mine/my_photo.png",
        "label": "我的相册",
        "page": MyPhotoPage()
      },
      {"icon": "assets/mine/level.png", "label": "我的等级", "page": LevelPage()},
      {"icon": "assets/mine/beauty.png", "label": "美颜设置"},
      {
        "icon": "assets/mine/protect.png",
        "label": "青少年模式",
        "page": TeenagerPage()
      },
      {
        "icon": "assets/mine/security.png",
        "label": "账号安全",
        "page": SecurityPage()
      },
      {"icon": "assets/mine/client.png", "label": "联系客服"},
      {
        "icon": "assets/mine/document.png",
        "label": "社区规范",
        "page": DocumentPage()
      },
      {"icon": "assets/mine/setting.png", "label": "系统设置", "page": SettingPage()},
    ];

    return Container(
      margin: EdgeInsets.fromLTRB(24, 8, 24, 8),
      padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '常用功能',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 0.0, // 增加纵向间距
            ),
            itemCount: functions.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (functions[index]["page"] != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => functions[index]["page"]),
                    );
                  } else {
                    // 弹出提示信息
                    showToast(
                      "正在开发中",
                      duration: const Duration(seconds: 2),
                      position: ToastPosition.bottom,
                      backgroundColor: Colors.black12,
                      textPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      textStyle: const TextStyle(color: Colors.black)
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      functions[index]["icon"]!,
                      fit: BoxFit.contain,
                      width: 24,
                    ),
                    const SizedBox(height: 4), // 减少图标和文字之间的距离
                    Text(
                      functions[index]["label"]!,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
