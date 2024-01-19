import 'package:carousel_slider/carousel_slider.dart';
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true, // 自动播放
                          enlargeCenterPage: false, // 禁用放大显示
                          viewportFraction: 0.9, // 图片占轮播容器的宽度比例
                        ),
                        items: const [
                          Image(image:AssetImage('assets/girls_voice/girl_voice_1.png')),
                          Image(image:AssetImage('assets/girls_voice/girl_voice_2.png')),
                          Image(image:AssetImage('assets/girls_voice/girl_voice_3.png')),
                          Image(image:AssetImage('assets/girls_voice/girl_voice_4.png')),
                          Image(image:AssetImage('assets/girls_voice/girl_voice_5.png')),
                          Image(image:AssetImage('assets/girls_voice/girl_voice_6.png')),
                          Image(image:AssetImage('assets/girls_voice/girl_voice_7.png')),
                          Image(image:AssetImage('assets/girls_voice/girl_voice_8.png')),
                          Image(image:AssetImage('assets/girls_voice/girl_voice_9.png')),
                          // 添加更多轮播项
                        ],
                      ),
                      const FeatureButton(imagePath: 'assets/home_marray_icon.png'),
                      const Column(
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
              ),
              const Expanded(
                child: UserListPage(), // 移动到正确的位置
              ),
            ],
          ),
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
