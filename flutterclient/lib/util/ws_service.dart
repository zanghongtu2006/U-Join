import 'dart:convert';

import 'package:flutterclient/util/api_service.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();

  factory ChatService() => _instance;

  StompClient? _stompClient;

  ChatService._internal();

  void _onConnectCallback(StompFrame frame) {
    // 连接成功的逻辑
    _stompClient?.send(
      destination: '/app/hello',
      body: jsonEncode({'name':'message from flutter'}),
    );
    _stompClient?.subscribe(
      destination: '/user/topic/greetings',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          // 处理收到的消息
          print('Recv reply: ${frame.body}');
        }
      },
    );
    _stompClient?.subscribe(
      destination: '/user/topic/chat-reply',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          // 处理收到的消息
        }
      },
    );
  }

  void _onDisconnected(StompFrame frame) {
    print('Disconnected from WebSocket: ${frame.body}');
    // 断开后，延时重连
    Future.delayed(Duration(seconds: 1), () {
      _connectWithRetry();
    });
  }

  void sendMessage(String destination, String message) {
    _stompClient?.send(
      destination: destination,
      body: message,
    );
  }

  void initialize() async {
    _connectWithRetry();
  }

  void _connectWithRetry() async {
    var token = await ApiService().getToken();
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://192.168.168.10:8080/chatserver',
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
        onConnect: _onConnectCallback,
        onDisconnect: _onDisconnected,
        onWebSocketError: (dynamic error) => print(error.toString()),
        onStompError: (StompFrame frame) => print('Stomp error: ${frame.body}'),
        // ... 其他配置 ...
      ),
    );
    _stompClient?.activate();
  }

  void disconnect() {
    _stompClient?.deactivate();
  }

  // void connectWithRetry() async {
  //   try {
  //     var token = await ApiService().getToken();
  //     print(token);
  //     _stompClient = StompClient(
  //       config: StompConfig.sockJS(
  //         url: 'http://192.168.168.10:8080/chatserver',
  //         webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
  //         onConnect: onConnectCallback,
  //         onWebSocketError: (e) => print(e.toString()),
  //         onStompError: (d) => print('error stomp'),
  //         heartbeatIncoming: const Duration(seconds: 10),
  //         heartbeatOutgoing: const Duration(seconds: 10),
  //         onDisconnect: (f) {
  //           print("=================token==================");
  //           onDisconnected();
  //           Future.delayed(const Duration(seconds: 1), () async {
  //             print("Disconnected, attempting to reconnect...");
  //             var token = ApiService().getToken();
  //             print("=================token==================");
  //             print(token);
  //             connectWithRetry(); // 重新连接
  //           });
  //         },
  //         // 其他配置...
  //       ),
  //     )
  //       ..activate();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
