import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterclient/util/api_service.dart';
import 'package:image_picker/image_picker.dart';

import '../chat_page/chat/file_viewer/audio_player.dart';
import '../chat_page/chat/file_viewer/file_util.dart';
import '../chat_page/chat/file_viewer/video_player_widget.dart'; // 引入图片选择器插件

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  late List<File> _selectedMedias = [];
  late String _fileType = 'IMAGE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _createPost();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: '分享新鲜事...',
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.transparent), // 设置边框颜色为透明
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.transparent), // 正常状态下边框颜色透明
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // 聚焦状态下边框颜色透明
                ),
              ),
              minLines: 10,
              maxLines: null,
              // 允许输入多行文本
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                    // 弹出模态框录音
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    backgroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      // 设定形状
                      borderRadius: BorderRadius.circular(8), // 去除圆角
                    ),
                    // 设置按钮按下时的背景颜色为透明
                    shadowColor: Colors.white70,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(100, 100),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 让Column占用的空间尽可能小
                    children: <Widget>[
                      Image.asset(
                        'assets/pic.png',
                        width: 50, // 调整图像的宽度
                        height: 50, // 调整图像的高度
                      ),
                      const Text(
                        '图片', // 说明文字
                        style: TextStyle(
                          color: Colors.black, // 文本颜色
                          fontSize: 14, // 文本大小
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _pickVideo();
                    // 弹出模态框录音
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    backgroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      // 设定形状
                      borderRadius: BorderRadius.circular(8), // 去除圆角
                    ),
                    // 设置按钮按下时的背景颜色为透明
                    shadowColor: Colors.white70,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(100, 100),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 让Column占用的空间尽可能小
                    children: <Widget>[
                      Image.asset(
                        'assets/audio.png',
                        width: 50, // 调整图像的宽度
                        height: 50, // 调整图像的高度
                      ),
                      const Text(
                        '视频', // 说明文字
                        style: TextStyle(
                          color: Colors.black, // 文本颜色
                          fontSize: 14, // 文本大小
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // 弹出模态框录音
                    _showRecordModal();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    backgroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      // 设定形状
                      borderRadius: BorderRadius.circular(8), // 去除圆角
                    ),
                    // 设置按钮按下时的背景颜色为透明
                    shadowColor: Colors.white70,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(100, 100),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 让Column占用的空间尽可能小
                    children: <Widget>[
                      Image.asset(
                        'assets/voice.png',
                        width: 50, // 调整图像的宽度
                        height: 50, // 调整图像的高度
                      ),
                      const Text(
                        '录音', // 说明文字
                        style: TextStyle(
                          color: Colors.black, // 文本颜色
                          fontSize: 14, // 文本大小
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_selectedMedias.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  // 使GridView适应内部大小
                  physics: const NeverScrollableScrollPhysics(),
                  // 禁止GridView滚动
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 每行显示3个媒体预览
                    crossAxisSpacing: 4, // 横向间距
                    mainAxisSpacing: 4, // 纵向间距
                  ),
                  itemCount: _selectedMedias.length,
                  itemBuilder: (BuildContext context, int index) {
                    switch (_fileType) {
                      case 'VIDEO':
                        return VideoPlayerWidget(
                            url: 'message.content.fileUrl', path: _selectedMedias[0].path);
                      case 'AUDIO':
                        return AudioPlayerWidget(
                          url: 'message.content.fileUrl', path: _selectedMedias[0].path, duration: 30);
                      case 'IMAGE':
                        return Image.file(
                          _selectedMedias[index],
                          fit: BoxFit.cover, // 填充方式
                        );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    // 弹出选择器选择图片、视频
    List<File> medias = await FileUtils.instance.directlyImagePicker();
    setState(() {
      _selectedMedias = medias;
      _fileType = 'IMAGE';
    });
  }

  Future<void> _pickVideo() async {
    // 弹出选择器选择图片、视频
    List<File> medias = await FileUtils.instance.directlyVideoPicker();
    setState(() {
      _selectedMedias = medias;
      _fileType = 'VIDEO';
    });
  }

  Future<void> _startRecording() async {}

  Future<void> _stopRecording() async {
    setState(() {
      _fileType = 'AUDIO';
    });
  }

  void _showRecordModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onLongPress: _startRecording,
                  onLongPressUp: _stopRecording,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent, // 按钮颜色
                      borderRadius: BorderRadius.circular(100), // 设置圆形
                    ),
                    alignment: Alignment.center,
                    width: 80,
                    // 圆形按钮的宽度
                    height: 80,
                    // 圆形按钮的高度
                    child: const Text('按住说话',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    String content = _contentController.text;
    late Map<String, dynamic> postData = {'content': content};
    switch (_fileType) {
      case 'IMAGE':
        postData['imageUrls'] = _selectedMedias;
        break;
      case 'VIDEO':
        postData['videoUrl'] = _selectedMedias[0];
        break;
      case 'AUDIO':
        postData['audioUrl'] = _selectedMedias[0];
        break;
    }
    // 发送POST请求创建新的帖子
    final response = await ApiService().post('/posts', postData);
    print('=========================${response.statusCode}');
    print('=========================${response.body}');
  }
}
