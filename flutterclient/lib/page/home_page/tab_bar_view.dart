import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("自定义Tab页"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // 如果需要Tab紧密排列，设置为false
          indicatorColor: Colors.blue, // 下划线颜色
          labelColor: Colors.blue, // 选中的Tab文字颜色
          unselectedLabelColor: Colors.black, // 未选中的Tab文字颜色
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
            Tab(text: 'Tab 4'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('内容 1')),
          Center(child: Text('内容 2')),
          Center(child: Text('内容 3')),
          Center(child: Text('内容 4')),
        ],
      ),
    );
  }
}
