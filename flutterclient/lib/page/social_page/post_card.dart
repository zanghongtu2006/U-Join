import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterclient/page/button/logo_button.dart';
import 'package:flutterclient/page/chat_page/chat.dart';

class PostCard extends StatelessWidget {
  final String avatar;
  final String name;
  final int age;
  final int height;
  final String content;
  final List<String> images;
  final String location;

  const PostCard({
    Key? key,
    required this.avatar,
    required this.name,
    required this.age,
    required this.height,
    required this.content,
    required this.images,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                backgroundImage: AssetImage(avatar),
              ),
              title:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4), // 增加 title 和 subtitle 之间的间隔
                  Text('$age岁 · $height厘米 · 质检QC', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(content)],
              ),
            ),
            const SizedBox(height: 8),
            _buildImages(context),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.grey, // 您想要的颜色
                      BlendMode.srcATop, // 保留透明度的同时应用颜色到非透明区域
                    ),
                    child: Image.asset(
                      'assets/icon/heart_empty.png',
                      width: 24.0,
                      height: 24.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('3'),
                  SizedBox(width: 40),
                  Image.asset('assets/icon/reply.png',
                      width: 24.0, // 图片的宽度
                      height: 24.0, // 图片的高度
                      fit: BoxFit.cover),
                  SizedBox(width: 8),
                  Text('3'),
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
                  Text(location, style: TextStyle(color: Colors.grey)),
                  const Spacer(),
                  LogoButton(
                    logoPath: 'assets/icon/love_chat_icon.png',
                    borderColor: Colors.grey,
                    borderWidth: 1.0,
                    text: '搭讪',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(userId: "hello",nickName: 'hello',avatar: "avatar",)), // TargetPage是要跳转到的页面
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
    if (images.length == 1) {
      return FutureBuilder(
        future: getImageDimensions(images.first),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final ImageInfo? imageInfo = snapshot.data as ImageInfo?;
            final double? imageHeight = imageInfo?.image.height.toDouble();
            final double? imageWidth = imageInfo?.image.width.toDouble();

            // 保持图片原始比例的同时适应屏幕宽度
            if (imageWidth != null && imageHeight != null) {
              final double screenWidth = MediaQuery.of(context).size.width;
              final double maxHeight = 300.0;
              final double ratio = imageWidth / imageHeight;
              final double adjustedWidth = screenWidth;
              final double adjustedHeight = adjustedWidth / ratio;
              final double finalHeight =
                  adjustedHeight > maxHeight ? maxHeight : adjustedHeight;
              final double finalWidth = finalHeight * ratio;

              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: finalWidth, // 仅设置容器宽度为图片的宽度
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // 设置圆角半径
                    child: Image.asset(
                      images.first,
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3列显示
          crossAxisSpacing: 10.0, // 列之间的间距
          mainAxisSpacing: 10.0, // 行之间的间距
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // 设置圆角半径
            child: Image.asset(
              images[index],
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
      AssetImage(assetName).resolve(ImageConfiguration.empty);
  final listener = ImageStreamListener((info, _) => completer.complete(info));
  stream.addListener(listener);
  return completer.future;
}

// 计算两张图片的高度比
double _calculateAspectRatio(List<String> images) {
  // 这里需要计算两张图片的最大高度，并得出宽度和高度的比例
  // 您需要实现一个函数来获取这两张图片的尺寸，然后计算比例
  // 示例返回值，实际需要根据图片尺寸进行计算
  return 1.5; // 这是宽高比例的示例值，需要您根据实际情况计算
}
