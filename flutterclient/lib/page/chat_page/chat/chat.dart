import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterclient/page/chat_page/chat/chat_service.dart';
import 'package:flutterclient/page/chat_page/chat/message_util.dart';
import 'package:flutterclient/page/chat_page/chat/ws_manager.dart';
import 'package:flutterclient/page/chat_page/model/chat_model.dart';
import 'package:flutterclient/util/data_cache.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart' as p;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';

import '../../../util/api_service.dart';
import '../../../util/db_manager.dart';
import '../model/user_model.dart';
import 'file_viewer/audio_player.dart';
import 'file_viewer/file_util.dart';
import 'file_viewer/image_viewer_fullscreen.dart';
import 'file_viewer/video_player_widget.dart';
import 'file_viewer/voice_input_widget.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String shortConversationId;
  final String avatar;
  final String nickName;
  final List<String> userIds;

  const ChatPage({
    Key? key,
    required this.conversationId,
    required this.shortConversationId,
    required this.avatar,
    required this.nickName,
    required this.userIds,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;
  bool _isPanelExpanded = false; // 用于控制面板展开/收缩的状态
  final ScrollController _scrollController = ScrollController();
  StompUnsubscribe? _unsubscribeReply; // 这是订阅的标识符
  StompUnsubscribe? _unsubscribeChat; // 这是订阅的标识符

  final Map<String, Timer> _timers = {};
  late User mine;
  late List<Message> _messages = [];
  late Map<String, User> _userMap = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadMessages();
    _subscribeTopic();
  }

  @override
  void dispose() {
    // 取消订阅
    _unsubscribeReply?.call();
    _unsubscribeChat?.call();
    if (_timers.isNotEmpty) {
      var keysToCancel = _timers.keys.toList();
      // 遍历键，取消并移除计时器
      for (String key in keysToCancel) {
        _timers[key]?.cancel();
        _timers.remove(key);
      }
    }
    super.dispose();
  }

  void _subscribeTopic() {
    StompClient? stompClient = WsManager().getStompClient();
    if (stompClient != null && stompClient.connected) {
      _unsubscribeReply = stompClient.subscribe(
        destination: '/user/topic/chat-reply',
        callback: (StompFrame frame) async {
          if (frame.body != null) {
            // 处理收到的消息
            String? body = frame.body;
            print('Chat reply: $body');
            if (body != null) {
              Message? message =
                  await MessageUtil.instance.dealReceived(body, mine.id);
              if (message != null) {
                _updateMessage(message);
              }
            }
          }
        },
      );
      _unsubscribeChat = stompClient.subscribe(
        destination: '/user/topic/chat',
        callback: (StompFrame frame) async {
          if (frame.body != null) {
            // 处理收到的消息
            String? body = frame.body;
            print('Chat received: $body');
            if (body != null) {
              Message? message =
                  await MessageUtil.instance.dealReceived(body, mine.id);
              if (message != null) {
                _appendMessage(message);
              }
            }
          }
        },
      );
    }
  }

  void _removeMessage(Message message) {
    setState(() {
      _messages
          .removeWhere((element) => element.messageId == message.messageId);
    });
  }

  void _retrySendMessage(Message message) {
    _removeMessage(message);
    _timers[message.messageId] = Timer(const Duration(seconds: 15), () {
      _updateMessageStatus(message.messageId);
    });
    ChatService.instance.retrySendMessage(message, _appendMessage);
  }

  void _sendMessage(Message message) async {
    _timers[message.messageId] = Timer(const Duration(seconds: 15), () {
      _updateMessageStatus(message.messageId);
    });
    ChatService.instance.sendMessage(message, _appendMessage);
  }

  void _sendFileMessage(Message message) async {
    _timers[message.messageId] = Timer(const Duration(seconds: 15), () {
      _updateMessageStatus(message.messageId);
    });
    ChatService.instance.sendFileMessage(message, _updateFileMessage);
  }

  void _appendMessage(Message message) {
    setState(() {
      _messages.add(message);
    });
    // 等待列表更新完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      // 设置一个延时再次尝试滚动到底部
      Future.delayed(const Duration(milliseconds: 2000), () {
        _scrollToBottom(); // 再次尝试滚动到底部
      });
    });
  }

  void _updateFileMessage() {}

  Future<void> _updateMessage(Message message) async {
    int indexToUpdate =
        _messages.indexWhere((msg) => msg.messageId == message.messageId);
    if (indexToUpdate != -1) {
      setState(() {
        _messages[indexToUpdate] = message;
      });
    }
  }

  Future<void> _updateMessageStatus(String messageId) async {
    Message message =
        await DatabaseManager.instance.findMessagesById(messageId);
    _updateMessage(message);
    _timers[messageId]?.cancel();
    _timers.remove(messageId);
  }

  void _onSendButtonPressed() async {
    // 消息文本
    String messageText = _textController.text;
    Message message = MessageUtil.instance.buildSendingMessage(
        widget.conversationId,
        widget.shortConversationId,
        mine,
        'TEXT',
        messageText,
        '',
        '',
        0);
    // 清除文本输入框
    _textController.clear();
    _sendMessage(message);
  }

  Future<void> _loadMoreMessages() async {
    final List<Message> messages = await DatabaseManager.instance
        .findMessagesByConversationId(widget.conversationId, _messages.length);
    final now = DateTime.now();
    for (var message in messages) {
      final difference = now.difference(message.timestamp).inSeconds;
      if (message.sendStatus == 'SENDING' && difference > 15) {
        message.sendStatus = 'FAILED';
      }
      message.sender = _userMap[message.senderId];
    }
    messages.addAll(_messages);
    setState(() {
      _messages = messages;
    });
  }

  void _loadMessages() async {
    final messages = await DatabaseManager.instance
        .findMessagesByConversationId(widget.conversationId, 0);
    final now = DateTime.now();
    for (var message in messages) {
      final difference = now.difference(message.timestamp).inSeconds;
      if (message.sendStatus == 'SENDING' && difference > 15) {
        message.sendStatus = 'FAILED';
      }
      message.sender = _userMap[message.senderId];
    }
    setState(() {
      _messages = messages;
    });
    // 等待列表更新完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      // 设置一个延时再次尝试滚动到底部
      Future.delayed(const Duration(milliseconds: 500), () {
        _scrollToBottom(); // 再次尝试滚动到底部
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _fetchUserData() async {
    List<User> users = await DataCache().fetchUserData(widget.userIds);
    _userMap = {for (var user in users) user.id: user};
    print(_userMap);
    var uid = await ApiService().getUid();
    if (uid != null) {
      for (var userData in users) {
        if (userData.id == uid) {
          setState(() {
            mine = User(
                id: userData.id,
                nickName: userData.nickName,
                avatar: userData.avatar,
                gender: userData.gender);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.nickName,
          style: const TextStyle(fontSize: 18),
        )), // 对方的名字或群聊名
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _loadMoreMessages();
              },
              child: ListView.builder(
                controller: _scrollController, // 使用控制器
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message.isMe;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: <Widget>[
                        if (!isMe) ...[
                          CircleAvatar(
                              backgroundImage: NetworkImage(widget.avatar)),
                          // 头像
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildMessageContent(message),
                            ],
                          ),
                        ] else ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(message.sendStatus),
                              Row(
                                children: [
                                  if (message.sendStatus == 'FAILED')
                                    IconButton(
                                      icon: const Icon(Icons.refresh,
                                          color: Colors.red),
                                      // 红色重试按钮
                                      onPressed: () {
                                        // 在此处处理重试逻辑
                                        _retrySendMessage(message);
                                      },
                                    ),
                                  _buildMessageContent(message),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                              backgroundImage: NetworkImage(
                                  _userMap[message.senderId]!.avatar)),
                          // 头像
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            child: _buildTextInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(Message message) {
    switch (message.content.type) {
      case 'TEXT':
        return Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(message.content.text,
              style: const TextStyle(color: Colors.white)), // 聊天内容
        );
      case 'IMAGE':
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  FullScreenImageViewer(imagePath: message.content.filePath),
            ));
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
            child:
                Image.file(File(message.content.filePath), fit: BoxFit.cover),
          ),
        );
      case 'AUDIO':
        return AudioPlayerWidget(
            url: message.content.fileUrl, path: message.content.filePath, duration: message.content.duration,);
      case 'VIDEO':
        return Container(
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
          // 设置最大尺寸
          child: VideoPlayerWidget(
              url: message.content.fileUrl, path: message.content.filePath),
        );
      default:
        return const SizedBox.shrink(); // 未知类型处理
    }
  }

  Future<void> _sendMedia() async {
    List<File> medias = await FileUtils.instance.directlyOpenFilePicker();
    // 处理选择的文件，例如显示文件名、上传文件等
    List<Message> fileMessagesToSend = [];
    for (File media in medias) {
      print("Upload file: ${media.path}");
      final fileSizeBytes = await media.length();
      final fileSizeMb = fileSizeBytes / (1024 * 1024);
      if (fileSizeMb > 200) {
        showToast('文件最大支持200MB',
            duration: const Duration(seconds: 2),
            position: ToastPosition.bottom,
            backgroundColor: Colors.black12,
            textPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            textStyle: const TextStyle(color: Colors.black));
        continue;
      }
      String extension = p.extension(media.path);
      FileContent fileContent = FileUtils.instance.getContentTypeFromExtension(extension);
      Message message = MessageUtil.instance.buildSendingMessage(
          widget.conversationId,
          widget.shortConversationId,
          mine,
          fileContent.contentType,
          fileContent.contentText,
          media.path,
          '',0);
      fileMessagesToSend.add(message);
      _appendMessage(message);
    }
    _copyAndSendFileMessage(fileMessagesToSend);
  }

  Future<void> _sendVoiceRecord(File voice, int duration) async {
    Message message = MessageUtil.instance.buildSendingMessage(
        widget.conversationId,
        widget.shortConversationId,
        mine,
        'AUDIO',
        '[语音]',
        voice.path,
        '',
        duration);
    _appendMessage(message);
    List<Message> fileMessagesToSend = [];
    fileMessagesToSend.add(message);
    _copyAndSendFileMessage(fileMessagesToSend);
  }

  Future<void> _copyAndSendFileMessage(List<Message> messages) async {
    for (Message message in messages) {
      File media = File(message.content.filePath);
      FileModel? uploaded = await FileUtils.instance.copyAndSendFile(media);
      if (uploaded != null) {
        message.content.filePath = uploaded.file.path;
        message.content.fileUrl = uploaded.uploadedUrl;
        _updateMessage(message);
        _sendFileMessage(message);
      } else {
        _removeMessage(message);
      }
    }
  }

  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.transparent, // 设置整行的底色
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // 这会使子控件填满横向空间
        children: [
          Row(
            children: <Widget>[
              _buildRecordIconButton('assets/chat/voice.png', _isRecording, () {
                setState(() {
                  _isRecording = !_isRecording;
                });
              }),
              Expanded(
                child: _isRecording
                    ? VoiceInputWidget(
                        onRecordingComplete: (File file, int duration) {
                          // 在这里处理录音完成后的逻辑，例如上传录音文件
                          // 或者将录音消息添加到聊天列表
                          print("录音文件路径: ${file.path}");
                          _sendVoiceRecord(file, duration);
                        },
                      )
                    : TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: '请输入...',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // 设置圆角的大小
                            borderSide: BorderSide.none, // 不显示边框线
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          // 设置输入框的填充色为白色
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8), // 根据需要调整内边距
                        ),
                        onSubmitted: (value) {
                          // 当键盘上的发送按钮被点击时，调用发送消息的逻辑
                          _onSendButtonPressed();
                        },
                      ),
              ),
              _buildIconButton('assets/chat/emoji.png', () {
                // 打开emoji选择器
              }),
              _buildIconButton('assets/chat/more.png', () {
                // 打开更多模态框
                setState(() {
                  _isPanelExpanded = !_isPanelExpanded; // 切换面板的展开/收缩状态
                });
                ;
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: _buildChatIcon('assets/chat/photo.png', () {
                _sendMedia();
              })),
              Expanded(
                  child: _buildChatIcon('assets/chat/phone.png', () {
                // 电话点击事件
              })),
              Expanded(
                  child: _buildChatIcon('assets/chat/present.png', () {
                // 礼物点击事件
              })),
              Expanded(
                  child: _buildChatIcon('assets/chat/vod.png', () {
                // 视频点击事件
              })),
              Expanded(
                  child: _buildChatIcon('assets/chat/gif.png', () {
                // GIF点击事件
              })),
            ],
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isPanelExpanded ? 200 : 0, // 根据_isPanelExpanded调整高度
            color: Colors.white, // 或者任何您喜欢的颜色
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child:
                            Image.asset('assets/chat/mock_cp.png', width: 60),
                      ),
                      const Text("假装情侣", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child:
                            Image.asset('assets/chat/icon_cp.png', width: 60),
                      ),
                      const Text("CP", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Image.asset('assets/chat/icon_qinmi.png',
                            width: 60),
                      ),
                      const Text("亲密关系", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Image.asset('assets/chat/shaizi.png', width: 60),
                      ),
                      const Text(
                        "掷骰子",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child:
                            Image.asset('assets/chat/caiquan.png', width: 60),
                      ),
                      const Text("猜拳", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Image.asset('assets/chat/zhenxinhua.png',
                            width: 60),
                      ),
                      const Text("真心话", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(String imagePath, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: Colors.transparent, // 按钮的背景色
      radius: 20, // 按钮的大小
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(imagePath,
              width: 24, height: 24), // 如果是String，使用Image
        ),
      ),
    );
  }

  Widget _buildRecordIconButton(
      dynamic iconOrImagePath, bool isRecording, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: Colors.transparent, // 按钮的背景色
      radius: 20, // 按钮的大小
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isRecording
              ? const Icon(Icons.keyboard) // 如果是IconData，使用Icon
              : Image.asset(iconOrImagePath,
                  width: 24, height: 24), // 如果是String，使用Image
        ),
      ),
    );
  }

  Widget _buildChatIcon(dynamic iconOrImagePath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(iconOrImagePath, width: 24, height: 24),
      ),
    );
  }
}
