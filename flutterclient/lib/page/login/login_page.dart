import 'package:flutter/material.dart';
import 'package:flutterclient/page/login/privacy_before_login.dart';
import 'package:flutterclient/util/api_service.dart';

import 'common_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    ApiService().clearToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/login_top_bg.png"), // 替换成你的背景图片
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter),
            ),
            height: MediaQuery.of(context).size.height * 0.55, // 将高度设置为屏幕高度的50%
          ),
          Align(
            alignment: Alignment.bottomCenter, // 将按钮放在图片的下方
            child: Padding(
              padding: const EdgeInsets.only(top: 256.0), // 调整按钮与图片的距离
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle phone number login
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            const Size(double.infinity, 48), // width and height
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.phone_android),
                          SizedBox(width: 8.0),
                          Text('手机号码自动登录'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle WeChat login
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.green,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.wechat),
                          SizedBox(width: 8.0),
                          Text('微信登录'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: FloatingActionButton(
                            heroTag: "hero-to-phone-login",
                            onPressed: () {
                              // 当点击时，导航到 CommonLogin 页面
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CommonLoginPage(),
                              ));
                            },
                            // 替换成你的注册 logo
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: Image.asset(
                                'assets/login_phone_icon.png'), // QQ logo 的背景色
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: FloatingActionButton(
                            heroTag: "hero-to-qq-login",
                            onPressed: () {
                              // 处理 QQ 登录
                            },
                            // 替换成你的 QQ logo
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: Image.asset(
                                'assets/login_qq_icon.png'), // QQ logo 的背景色
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomSheet: Container(
        height: 40,
        child: const Align(
          // 使用 Align 来水平居中显示 PrivacyBeforeLoginWidget
          alignment: Alignment.center,
          child: PrivacyBeforeLoginWidget(),
        ),
      ),
    );
  }
}
