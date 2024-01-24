import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;

  // 假设的聊天记录
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'Alice',
      'text': 'Hello, how are you?',
      'timestamp': DateTime.now().subtract(Duration(minutes: 2)),
      'isMe': false,
    },
    {
      'sender': '零下十一度',
      'text': 'I am fine, thanks!',
      'timestamp': DateTime.now().subtract(Duration(minutes: 1)),
      'isMe': true,
    },
    // 更多消息...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:Text("Alice")), // 对方的名字或群聊名
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['isMe'];
                return Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: <Widget>[
                    if (!isMe) ...[
                      CircleAvatar(child: Text(message['sender'][0])), // 头像
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(message['sender']), // 显示发送者名字
                          Container(
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(message['text']), // 聊天内容
                          ),
                        ],
                      ),
                    ] else ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(message['sender']), // 显示发送者名字
                          Container(
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(message['text'],
                                style: TextStyle(color: Colors.white)), // 聊天内容
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(child: Text(message['sender'][0])), // 头像
                    ],
                  ],
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            child: _buildTextInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.transparent, // 设置整行的底色
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // 这会使子控件填满横向空间
        children: [
          Row(
            children: <Widget>[
              _buildRecordIconButton(
                  'assets/chat/voice.png', _isRecording, () {
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
                          child: Text('Hold to record'),
                        ),
                      )
                    : TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // 设置圆角的大小
                            borderSide: BorderSide.none, // 不显示边框线
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          // 设置输入框的填充色为白色
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8), // 根据需要调整内边距
                        ),
                      ),
              ),
              _buildIconButton('assets/chat/emoji.png', () {
                // 打开emoji选择器
              }),
              _buildIconButton('assets/chat/more.png', () {
                // 打开更多模态框
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
        ],
      ),
    );
  }

  Widget _buildIconButton(String imagePath, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200], // 按钮的背景色
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
