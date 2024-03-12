import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video_player_fullscreen.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final String path;

  const VideoPlayerWidget({Key? key, required this.url, this.path = ''})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false; // 新增一个状态变量来跟踪视频是否正在播放

  @override
  void initState() {
    super.initState();
    // 根据path是否为空选择初始化方法
    if (widget.path.isNotEmpty) {
      _controller = VideoPlayerController.file(File(widget.path));
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    }

    _controller.initialize().then((_) {
      // 监听视频播放状态变化
      _controller.addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      });
      setState(() {}); // 当视频初始化后需要刷新Widget
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击视频任意位置控制播放或暂停
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              FullScreenVideoPlayer(url: widget.url, path: widget.path),
        ));
      },
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _PlayPauseOverlay(controller: _controller), // 添加一个播放/暂停覆盖层
                  VideoProgressIndicator(_controller, allowScrubbing: true), // 显示进度条
                  Positioned( // 添加显示时长的 Widget
                    right: 5,
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      color: Colors.black12, // 半透明背景提高可读性
                      child: Text(
                        _formatDuration(_controller.value.duration),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: 200, // 可以设置一个默认高度
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

// 播放/暂停覆盖层的实现
class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink() // 如果视频正在播放，则不显示任何东西
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 60.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
      ],
    );
  }

}
