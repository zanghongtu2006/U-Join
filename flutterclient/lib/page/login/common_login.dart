import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterclient/main.dart';
import 'package:oktoast/oktoast.dart';

import '../../util/api_service.dart';
import 'register_page.dart';

class CommonLoginPage extends StatefulWidget {
  const CommonLoginPage({Key? key}) : super(key: key);

  @override
  _CommonLoginPageState createState() => _CommonLoginPageState();
}

class _CommonLoginPageState extends State<CommonLoginPage> {
  bool _passwordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登录"),
        backgroundColor: Colors.transparent, // 设置 AppBar 背景为透明
        elevation: 0, // 取消 AppBar 阴影
      ),
      extendBodyBehindAppBar: true, // 允许 body 扩展到 AppBar 下方
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
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 256.0), // 调整按钮与图片的距离
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 48.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "用户名",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // 在这里设置圆角半径
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: "密码",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // 在这里设置圆角半径
                          ),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // 根据密码是否可见显示不同的图标
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              // 更新状态以切换密码可见性
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      // 调用登录API
                      var response = await ApiService().post(
                        '/token/login',
                        {'username': username, 'password': password},
                      );
                      if (response.statusCode == 200) {
                        var result = json.decode(response.body);
                        print(result['data']);
                        // 存储token
                        await ApiService().setToken(
                            result['data']['access-token'],
                            result['data']['refresh-token']);
                        // 跳转到首页或其他页面
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                      } else {
                        // 显示错误信息
                        showToast("用户名或密码错误",
                            duration: const Duration(seconds: 2),
                            position: ToastPosition.bottom,
                            backgroundColor: Colors.black12,
                            textPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            textStyle: const TextStyle(color: Colors.black));
                      }
                    },
                    child: const Text("登录"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("如果没有账号，请"),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ));
                        },
                        child: const Text(
                          "【注册】",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  // 其他登录相关的按钮和逻辑
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
