import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutterclient/page/chat_page/chat/file_viewer/file_util.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(File file, int duration) onRecordingComplete;
  const VoiceInputWidget({Key? key, required this.onRecordingComplete}) : super(key: key);

  @override
  _VoiceInputWidgetState createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  void _startTimer() {
    // 初始化录音时长
    _recordDuration = Duration.zero;
    // 设置定时器每秒更新一次录音时长
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _recordDuration = Duration(seconds: _recordDuration.inSeconds + 1);
      });
    });
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) return;
    setState(() {
      _isRecording = true; // 开始录音时设置为true
    });
    _startTimer();
    String filePath = await FileUtils.instance.getTargetFilePath(".aac");
    await _recorder.startRecorder(toFile: filePath);
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderInitialized) return;
    setState(() {
      _isRecording = false; // 开始录音时设置为true
    });
    String? path = await _recorder.stopRecorder();
    _timer?.cancel();
    if (path != null) {
      print("====================_stopRecording:$path");
      widget.onRecordingComplete(File(path), _recordDuration.inSeconds);
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _startRecording,
      onLongPressUp: _stopRecording,
      child: Container(
        color: Colors.blueGrey,
        alignment: Alignment.center,
        height: 48,
        child: Text(_isRecording ? '正在录音 ${_recordDuration.inSeconds} 秒...' : '按住 说话'),
      ),
    );
  }
}
