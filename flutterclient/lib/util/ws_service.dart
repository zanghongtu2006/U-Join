import 'dart:convert';

import 'package:flutterclient/util/api_service.dart';
import 'package:flutterclient/util/message_util.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();

  factory ChatService() => _instance;

  StompClient? _stompClient;

  ChatService._internal();

  StompClient? getStompClient() {
    return _stompClient;
  }

  void _onConnectCallback(StompFrame frame) {
    // 连接成功的逻辑
    _stompClient?.send(
      destination: '/app/hello',
      body: jsonEncode({'name': 'message from flutter'}),
    );
    _stompClient?.subscribe(
      destination: '/user/topic/greetings',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          // 处理收到的消息
          print('Recv reply ----------------------: ${frame.body}');
        }
      },
    );
    _stompClient?.subscribe(
      destination: '/user/topic/chat-reply',
      callback: (StompFrame frame) async {
        if (frame.body != null) {
          // 处理收到的消息
          String? body = frame.body;
          print('======Chat reply: $body');
          String? uid = await ApiService().getUid();
          MessageUtil.instance.dealReceived(body!, uid!);
        }
      },
    );
  }

  void _onDisconnected(StompFrame frame) {
    print('Disconnected from WebSocket: ${frame.body}');
    // 断开后，延时重连
    Future.delayed(const Duration(seconds: 1), () {
      _connectWithRetry();
    });
  }

  void _onWebSocketError(dynamic error) {
    print('WebSocketError from WebSocket: $error');
  }

  void _onStompError(StompFrame frame) {
    print('Disconnected from WebSocket: ${frame.body}');
  }

  bool sendMessage(String destination, String message) {
    try {
      _stompClient?.send(
        destination: destination,
        body: message,
      );
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void initialize() async {
    print("---------------------initialize--------------------");
    _connectWithRetry();
  }

  void _connectWithRetry() async {
    var token = await ApiService().getToken();
    print('===================token==========================$token');
    if (token == null || token == '') {
      return;
    }
    if (ApiService().isTokenExpired(token)) {
      await ApiService().refreshToken();
      var token = await ApiService().getToken();
      print(
          '===================token refresed==========================$token');
      if (token == null || token == '') {
        return;
      }
    }
    // 如果已有连接活跃，先断开
    if (_stompClient != null && _stompClient!.connected) {
      _stompClient!.deactivate();
    }
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://192.168.168.15:8080/chatserver',
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
        onConnect: _onConnectCallback,
        onDisconnect: _onDisconnected,
        onWebSocketError: _onWebSocketError,
        onStompError: _onStompError,
        // ... 其他配置 ...
      ),
    );
    _stompClient?.activate();
  }

  void disconnect() {
    _stompClient?.deactivate();
  }
}
