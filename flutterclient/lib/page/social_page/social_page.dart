import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterclient/page/chat_page/model/post_model.dart';
import 'package:flutterclient/page/social_page/post_card.dart';
import 'package:flutterclient/page/social_page/post_create.dart';
import 'package:flutterclient/util/api_service.dart';

import 'filter_button.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> with SingleTickerProviderStateMixin {
  late String _searchType = 'RANDOM';
  final ScrollController _scrollController = ScrollController();
  late int _pageIndex = 1;
  late final int _pageSize = 10;
  late bool _isLoading = false;
  late List<Post> _posts = [];
  final Map<String, dynamic> _searchParams = {};

  @override
  void initState() {
    super.initState();
    _searchParams['pageIndex'] = _pageIndex;
    _searchParams['pageSize'] = _pageSize;
    _fetchPosts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    try {
      List<Post> posts = await _fetchNewPosts();
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Post>> _fetchNewPosts() async {
    if (_isLoading) return [];
    setState(() {
      _isLoading = true;
    });
    _searchParams['type'] = _searchType;
    var response = await ApiService().get('/posts', params: _searchParams);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      List<Post> posts = List<Post>.from(data['rows'].map((item) => Post.fromMap(item)));
      setState(() {
        _isLoading = false;
      });
      return posts;
    } else {
      setState(() {
        _isLoading = false;
      });
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: _fetchPosts,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              FilterButtons(
                // 使用 FilterButtons 组件
                onSelected: (index) {
                  setState(() {
                    // 根据不同的筛选条件触发不同的操作
                    switch (index) {
                      case 0:
                        setState(() {
                          _searchParams['pageIndex'] = 1;
                          _searchType = 'RANDOM';
                        });
                        _fetchPosts();
                        break;
                      case 1:
                        setState(() {
                          _searchParams['pageIndex'] = 1;
                          _searchType = 'LATEST';
                        });
                        _fetchPosts();
                        // 处理最新筛选条件
                        break;
                      case 2:
                        setState(() {
                          _searchParams['pageIndex'] = 1;
                          _searchType = 'VOICE';
                        });
                        _fetchPosts();
                        // 处理声控筛选条件
                        break;
                      case 3:
                        setState(() {
                          _searchParams['pageIndex'] = 1;
                          _searchType = 'FOCUS';
                        });
                        _fetchPosts();
                        // 处理关注筛选条件
                        break;
                      default:
                        break;
                    }
                  });
                },
                onFilter: () {
                  // 处理筛选按钮点击事件
                  // 可以弹出筛选条件的底部弹窗或执行其他操作
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: _posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _posts.length) {
                      // 列表最后一项，展示加载指示器
                      return _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    }
                    Post post = _posts[index];
                    return PostCard(post: post); // 使用你的UserTabView组件展示用户信息
                  },
                ),
              ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        mini: true,
        shape: const CircleBorder(),
        backgroundColor: Colors.indigoAccent,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
