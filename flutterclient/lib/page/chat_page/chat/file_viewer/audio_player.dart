import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;
  final String path;
  final int duration;

  const AudioPlayerWidget({Key? key, required this.url, required this.path, required this.duration})
      : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double barWidth = 50.0; // 初始长条宽度

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) { // 检查State对象是否仍然挂载在Widget树中
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
    setState(() {
      _updateBarWidth();
    });
  }

  void _updateBarWidth() {
    const double minBarWidth = 50.0;
    const double maxBarWidth = 200.0;
    const maxDurationSec = 180.0; // 假设最长音频为180秒
    double durationSec = widget.duration.toDouble();
    double widthRatio = durationSec / maxDurationSec;
    barWidth = minBarWidth + (maxBarWidth - minBarWidth) * widthRatio;
    barWidth = barWidth.clamp(minBarWidth, maxBarWidth); // 保证宽度在最小和最大值之间
  }

  @override
  Widget build(BuildContext context) {
    // 用一个Container包裹IconButton，以显示长条和图标
    return Container(
      width: barWidth, // 使用计算出的宽度
      height: 40, // 高度可以固定
      decoration: BoxDecoration(
        color: Colors.green[300], // 设置背景颜色
        borderRadius: BorderRadius.circular(20), // 设置圆角
      ),
      child: Center(
        child: IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
          onPressed: _togglePlayPause,
        ),
      ),
    );
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      if (widget.path.isEmpty) {
        await audioPlayer.setSourceUrl(widget.url);
      } else {
        await audioPlayer.setSourceDeviceFile(widget.path);
      }
      await audioPlayer.resume(); // 使用resume而不是play，以支持从暂停处播放
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}

