import 'package:flutter/material.dart';
import 'package:flutterclient/page/login/login_page.dart';

import '../button/logo_button.dart';
import 'user_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        backgroundColor: Colors.transparent, // 设置 AppBar 背景为透明
        elevation: 0,
        actions: <Widget>[
          LogoButton(
            logoPath: 'assets/icon/calendar.png',
            text: '任务',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()), // TargetPage是要跳转到的页面
              );
            },
          ),
          const SizedBox(width: 10),
          LogoButton(
            logoPath: 'assets/icon/rank.png',
            text: '排行榜',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()), // TargetPage是要跳转到的页面
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      extendBodyBehindAppBar: true, // 允许 body 扩展到 AppBar 下方
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            // 从顶部开始
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.20,
            // 设置高度为屏幕高度的20%
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/home_top_bg.png"),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                flex: 0,
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: const <Widget>[
                    FeatureButton(imagePath: 'assets/home_marray_icon.png'),
                    FeatureButton(imagePath: 'assets/home_marray_icon.png'),
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: FeatureButton(
                            imagePath: 'assets/home_test_icon.png',
                            isSmall: true,
                          ),
                        ),
                        Expanded(
                          child: FeatureButton(
                            imagePath: 'assets/home_voice_icon.png',
                            isSmall: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: UserListPage(), // 移动到正确的位置
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (int index) {
          // 更新状态以切换页面
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '交友'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String imagePath;
  final bool isSmall;

  const FeatureButton({
    Key? key,
    required this.imagePath,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 处理按钮点击事件
      },
      child: Card(
        child: SizedBox(
          width: isSmall ? 150 : 120,
          height: isSmall ? 60 : 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                // 使用 Expanded 使图片填充可用空间
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover, // 图片铺满整个容器
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
