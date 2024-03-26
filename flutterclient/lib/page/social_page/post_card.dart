import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterclient/page/button/logo_button.dart';
import 'package:flutterclient/page/chat_page/chat/chat.dart';
import 'package:flutterclient/util/api_service.dart';

import '../../util/chat_util.dart';
import '../../util/db_manager.dart';
import '../chat_page/model/conversation_model.dart';
import '../chat_page/model/post_model.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post _post;
  final List<String> _userIds = [];
  late String _conversationId;
  late String _shortConversationId;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _buildConversationIds();
  }

  Future<void> _buildConversationIds() async {
    String myUid = await ApiService().getUid();
    setState(() {
      _userIds.add(_post.userInfo.id);
      _userIds.add(myUid);
      _conversationId = ChatUtils.generateConversationId(_userIds);
      _shortConversationId =
          _conversationId.substring(0, 8) + _conversationId.substring(36, 44);
    });
  }

  Future<void> _likeOrUnlike(String id) async {
    setState(() {
      _post.like = !_post.like;
      if (_post.like) {
        _post.likeCount = _post.likeCount + 1;
      } else {
        _post.likeCount = _post.likeCount - 1;
      }
    });

    var response = await ApiService().post('/posts/like/$id', {});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      Post post = Post.fromMap(data);
      setState(() {
        _post = post;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1.0), // 设置浅灰色边框
        borderRadius: BorderRadius.circular(4.0), // 如果需要，可以设置边框圆角
      ),
      child: Card(
        margin: const EdgeInsets.fromLTRB(8, 0, 16, 16),
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(_post.userInfo.avatar),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_post.userInfo.nickName,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4), // 增加 title 和 subtitle 之间的间隔
                  Text(
                      '${_post.userInfo.age}岁 · ${_post.userInfo.height}厘米 · ${_post.userInfo.job}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(_post.content)],
              ),
            ),
            const SizedBox(height: 8),
            _buildImages(context),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _likeOrUnlike(_post.id);
                    },
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        _post.like ? Colors.redAccent : Colors.grey,
                        // 您想要的颜色
                        BlendMode.srcATop, // 保留透明度的同时应用颜色到非透明区域
                      ),
                      child: Image.asset(
                        _post.like
                            ? 'assets/icon/heart_fill_red.png'
                            : 'assets/icon/heart_empty.png',
                        width: 24.0,
                        height: 24.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${_post.likeCount}'),
                  const SizedBox(width: 40),
                  Image.asset('assets/icon/reply.png',
                      width: 24.0, // 图片的宽度
                      height: 24.0, // 图片的高度
                      fit: BoxFit.cover),
                  const SizedBox(width: 8),
                  Text('${_post.replyCount}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/icon/location.png',
                    height: 16, // 图标的高度
                    width: 16, // 图标的宽度
                  ),
                  const SizedBox(width: 8),
                  Text(_post.location,
                      style: const TextStyle(color: Colors.grey)),
                  const Spacer(),
                  LogoButton(
                    logoPath: 'assets/icon/love_chat_icon.png',
                    borderColor: Colors.grey,
                    borderWidth: 1.0,
                    text: '搭讪',
                    onPressed: () {
                      Conversation conversation = Conversation(
                          conversationId: _conversationId,
                          shortConversationId: _shortConversationId,
                          nickName: _post.userInfo.nickName,
                          type: 'PERSON',
                          avatar: _post.userInfo.avatar,
                          lastMessage: '',
                          userIds: _userIds,
                          unReadCount: 0,
                          gender: _post.userInfo.gender,
                          lastUpdateTime: DateTime.now());
                      DatabaseManager.instance
                          .insertOrUpdateConversation(conversation);
                      print("=======================${conversation.toJson()}");
                      ApiService()
                          .post("/conversations", conversation.toJson());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            userIds: _userIds,
                            conversationId: _conversationId,
                            shortConversationId: _shortConversationId,
                            nickName: _post.userInfo.nickName,
                            avatar: _post.userInfo.avatar,
                          ),
                        ), // TargetPage是要跳转到的页面
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImages(BuildContext context) {
    if (_post.imageUrls.length == 1) {
      return FutureBuilder(
        future: getImageDimensions(_post.imageUrls.first),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final ImageInfo? imageInfo = snapshot.data;
            final double? imageHeight = imageInfo?.image.height.toDouble();
            final double? imageWidth = imageInfo?.image.width.toDouble();

            // 保持图片原始比例的同时适应屏幕宽度
            if (imageWidth != null && imageHeight != null) {
              final double screenWidth = MediaQuery.of(context).size.width;
              const double maxHeight = 300.0;
              final double ratio = imageWidth / imageHeight;
              final double adjustedWidth = screenWidth;
              final double adjustedHeight = adjustedWidth / ratio;
              final double finalHeight =
                  adjustedHeight > maxHeight ? maxHeight : adjustedHeight;
              final double finalWidth = finalHeight * ratio;

              return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: finalWidth, // 仅设置容器宽度为图片的宽度
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // 设置圆角半径
                    child: Image.network(
                      _post.imageUrls.first,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      // 多张图片的情况
      return GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3列显示
          crossAxisSpacing: 10.0, // 列之间的间距
          mainAxisSpacing: 10.0, // 行之间的间距
        ),
        itemCount: _post.imageUrls.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // 设置圆角半径
            child: Image.network(
              _post.imageUrls[index],
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
  }
}

// 获取图片的宽度和高度信息
Future<ImageInfo?> getImageDimensions(String assetName) async {
  final Completer<ImageInfo?> completer = Completer<ImageInfo?>();
  final ImageStream stream =
      NetworkImage(assetName).resolve(ImageConfiguration.empty);
  final listener = ImageStreamListener((info, _) => completer.complete(info));
  stream.addListener(listener);
  return completer.future;
}
