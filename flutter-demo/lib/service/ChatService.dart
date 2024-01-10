import 'dart:convert';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatService {
  late StompClient stompClient;

  void connectWithRetry() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://192.168.168.15:8080/chatserver',
        webSocketConnectHeaders: {'Authorization': 'your_token'},
        onConnect: onConnectCallback,
        onWebSocketError: (e) => print(e.toString()),
        onStompError: (d) => print('error stomp'),
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
        onDisconnect: (f) {
          onDisconnected();
          Future.delayed(const Duration(seconds: 1), () {
            connectWithRetry(); // 重新连接
          });
        },
        // 其他配置...
      ),
    )..activate();
  }

  void onDisconnected() {
    print('Disconnected from WebSocket');
  }

  void onConnectCallback(StompFrame frame) {
    // 连接成功时的回调
    // 订阅或发送消息
    // HelloMessage helloMessage = HelloMessage('name');
    stompClient.send(
      destination: '/app/hello',
      body: jsonEncode({'name':'message from flutter'}),
    );
    stompClient.subscribe(
      destination: '/user/topic/greetings',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          // 处理收到的消息
          print('Recv reply: ${frame.body}');
        }
      },
    );
    stompClient.subscribe(
      destination: '/user/topic/chat-reply',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          // 处理收到的消息
        }
      },
    );
  }

  // 确保在适当的时候调用
  void disconnect() {
    stompClient.deactivate();
  }
}
