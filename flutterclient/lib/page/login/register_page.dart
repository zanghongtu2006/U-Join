import 'package:flutter/material.dart';
import 'package:flutterclient/page/login/profile/user_info.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("注册"),
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
                        decoration: InputDecoration(
                          labelText: "用户名",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          prefixIcon: const Icon(Icons.person),
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
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: "密码",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            prefixIcon: const Icon(Icons.lock),
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
                        )),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInformationPage(),
                        ),
                      );
                    },
                    child: const Text("注册"),
                  ),
                  // 可以添加更多的控件和逻辑
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
