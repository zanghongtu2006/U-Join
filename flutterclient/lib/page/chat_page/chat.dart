import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterclient/page/chat_page/model/chat_model.dart';
import 'package:flutterclient/util/message_util.dart';
import 'package:flutterclient/util/ws_service.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';

import '../../util/api_service.dart';
import '../../util/chat_util.dart';
import '../../util/db_manager.dart';

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
  final Map<String, Timer> _timers = {};
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;
  bool _isPanelExpanded = false; // 用于控制面板展开/收缩的状态
  final ScrollController _scrollController = ScrollController();
  StompUnsubscribe? _unsubscribe; // 这是订阅的标识符

  late String myUid;
  late String myAvatar;
  late String myNickName;
  late List<ChatModel> _messages = [];

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
    _unsubscribe?.call();
    for (String key in _timers.keys) {
      _timers[key]?.cancel();
      _timers.remove(key);
    }
    super.dispose();
  }

  void _subscribeTopic() {
    StompClient? stompClient = ChatService().getStompClient();
    if (stompClient != null && stompClient.connected) {
      _unsubscribe = stompClient.subscribe(
        destination: '/user/topic/chat-reply',
        callback: (StompFrame frame) async {
          if (frame.body != null) {
            // 处理收到的消息
            String? body = frame.body;
            print('Chat reply: $body');
            if (body != null) {
              ChatModel? message =
                  await MessageUtil.instance.dealReceived(body, myUid);
              if (message != null) {
                _loadMessages();
              }
            }
          }
        },
      );
    }
  }

  void _retrySendMessage(ChatModel chatModel) async {
    await DatabaseManager.instance.deleteMessage(chatModel.messageId);
    _removeMessage(chatModel.messageId);
    String messageId = ChatUtils.generateMessageId(widget.shortConversationId);
    chatModel.messageId = messageId;
    chatModel.timestamp = DateTime.now();
    chatModel.status = Status(
      read: true,
      sendTime: DateTime.now(),
    );
    chatModel.sendStatus = "SENDING";
    _sendMessage(chatModel);
  }

  void _removeMessage(String messageId) {
    setState(() {
      _messages.removeWhere((element) => element.messageId == messageId);
    });
    // 等待列表更新完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _appendMessage(ChatModel chatModel) {
    setState(() {
      _messages.add(chatModel);
    });
    // 等待列表更新完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(ChatModel chatModel) async {
    bool sendResult = await MessageUtil.instance.sendMessage(chatModel);
    if (!sendResult) {
      _setMessageFailed(chatModel);
    } else {
      _appendMessage(chatModel);
      _timers[chatModel.messageId] = Timer(const Duration(seconds: 1), () {
        _updateMessageStatus(chatModel.messageId);
      });
      // 设置定时器，在5秒后检查是否收到反馈
      MessageUtil.instance.putMessageTimers(chatModel);
    }
  }

  Future<void> _updateMessageStatus(String messageId) async {
    ChatModel message =
        await DatabaseManager.instance.findMessagesById(messageId);
    if (message.sendStatus != 'SENDING') {
      List<ChatModel> messages = _messages;
      for (ChatModel chatModel in messages) {
        if (chatModel.messageId == messageId) {
          chatModel.sendStatus = message.sendStatus;
        }
      }
      setState(() {
        _messages = messages;
      });
      _timers[messageId]?.cancel();
      _timers.remove(messageId);
    }
  }

  void _onSendButtonPressed() async {
    // 消息文本
    String messageText = _textController.text;
    // 生成消息ID
    String messageId = ChatUtils.generateMessageId(widget.shortConversationId);
    // 构建消息模型
    final chatModel = ChatModel(
      messageId: messageId,
      conversationId: widget.conversationId,
      shortConversationId: widget.shortConversationId,
      isMe: true,
      senderId: myUid,
      sender: User(
        id: myUid,
        nickName: myNickName,
        avatar: myAvatar,
      ),
      content: Content(
        type: "TEXT",
        text: messageText,
      ),
      timestamp: DateTime.now(),
      messageType: "CHAT",
      status: Status(
        read: true,
        sendTime: DateTime.now(),
      ),
      sendStatus: "SENDING",
      additionalInfo: AdditionalInfo(
        replyToMessageId: "",
      ),
    );
    // 清除文本输入框
    _textController.clear();
    _sendMessage(chatModel);
  }

  Future<void> _setMessageFailed(ChatModel chatModel) async {
    print("========================send failed=========================");
    chatModel.sendStatus = 'FAILED';
    await DatabaseManager.instance.insertMessage(chatModel);
    _appendMessage(chatModel);
  }

  void _loadMessages() async {
    final messages = await DatabaseManager.instance
        .findMessagesByConversationId(widget.conversationId);
    final senderIds =
        messages.map((message) => message.senderId).toSet().toList();
    final List<User> senders =
        await DatabaseManager.instance.findUsersByIds(senderIds);
    final senderMap = {for (var sender in senders) sender.id: sender};
    final now = DateTime.now();
    for (var message in messages) {
      final difference = now.difference(message.timestamp).inSeconds;
      if (message.sendStatus == 'SENDING' && difference > 15) {
        message.sendStatus = 'FAILED';
      }
      message.sender = senderMap[message.senderId];
    }
    setState(() {
      _messages = messages;
    });
    // 等待列表更新完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _fetchUserData() async {
    try {
      var combinedIds = widget.userIds.join(',');
      final Map<String, String> params = {'id': combinedIds};
      var response = await ApiService().get("/users", params: params);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        List<User> users =
            List<User>.from(data.map((item) => User.fromMap(item)));
        DatabaseManager.instance.insertOrUpdateUsers(users);
        var uid = await ApiService().getUid();
        if (uid != null) {
          for (var userData in users) {
            if (userData.id == uid) {
              setState(() {
                myUid = userData.id; // 确保数据中有 'id' 字段
                myNickName = userData.nickName ?? '';
                myAvatar = userData.avatar ?? '';
              });
            }
          }
        }
      }
    } catch (e) {
      print(e);
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
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: <Widget>[
                      if (!isMe) ...[
                        CircleAvatar(
                            backgroundImage: NetworkImage(widget.avatar)), // 头像
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(message.content.text), // 聊天内容
                            ),
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
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(message.content.text,
                                      style: const TextStyle(
                                          color: Colors.white)), // 聊天内容
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                            backgroundImage:
                                NetworkImage(message.sender!.avatar)),
                        // 头像
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: _buildTextInput(),
          ),
        ],
      ),
    );
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
                    ? GestureDetector(
                        onLongPress: () {
                          // 开始录音
                        },
                        onLongPressUp: () {
                          // 结束录音
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 48,
                          child: const Text('按住 说话'),
                        ),
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
                // 图片点击事件
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
