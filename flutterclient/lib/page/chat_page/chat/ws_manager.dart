import 'dart:convert';

import 'package:flutterclient/util/api_service.dart';
import 'package:flutterclient/page/chat_page/chat/message_util.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WsManager {
  static final WsManager _instance = WsManager._internal();
  factory WsManager() => _instance;
  WsManager._internal();

  StompClient? _stompClient;

  StompClient? getStompClient() {
    return _stompClient;
  }

  bool connected = false;

  void _onConnectCallback(StompFrame frame) {
    connected = true;
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
      destination: '/user/topic/chat',
      callback: (StompFrame frame) async {
        if (frame.body != null) {
          // 处理收到的消息
          String? body = frame.body;
          print('======Chat received: $body');
          String? uid = await ApiService().getUid();
          MessageUtil.instance.dealReceived(body!, uid!);
        }
      },
    );
  }

  void _onDisconnected(StompFrame frame) {
    connected = false;
    print('Disconnected from WebSocket: ${frame.body}');
    // 断开后，延时重连
    Future.delayed(const Duration(seconds: 1), () {
      _connectWithRetry();
    });
  }

  void _onWebSocketError(dynamic error) {
    connected = false;
    print('WebSocketError from WebSocket: $error');
    ApiService().refreshToken();
    _connectWithRetry();
  }

  void _onStompError(StompFrame frame) {
    connected = false;
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
    if(connected) {
      return;
    }
    // 如果已有连接活跃，先断开
    if (_stompClient != null && _stompClient!.connected) {
      _stompClient!.deactivate();
    }
    var token = await ApiService().getToken();
    print("--------------------connectwithretry====================$token");
    if (token == null || token == '') {
      return;
    }
    if (ApiService().isTokenExpired(token)) {
      await ApiService().refreshToken();
      var token = await ApiService().getToken();
      if (token == null || token == '') {
        return;
      }
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
