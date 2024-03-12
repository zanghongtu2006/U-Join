import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String url;
  final String path;

  const FullScreenVideoPlayer({Key? key, required this.url, this.path = ''})
      : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = widget.path.isNotEmpty
        ? VideoPlayerController.file(File(widget.path))
        : VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller.setLooping(false);

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      _controller.play(); // 添加这行代码使视频在初始化后自动播放
    });// Optional: 设置循环播放
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                // 点击屏幕切换播放/暂停状态
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Center(child: VideoPlayer(_controller)),
                  _buildPlayPauseOverlay(),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildPlayPauseOverlay() {
    return _controller.value.isPlaying
        ? Container() // 视频播放时，不显示任何东西
        : Container(
            alignment: Alignment.center,
            color: Colors.black26,
            child: Icon(Icons.play_circle_outline, color: Colors.white, size: 60),
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
