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
  int _retryCount = 0;
  final int _maxRetry = 5;

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
    _retryCount = 0;
  }

  bool shouldReconnectBasedOnStompError(StompFrame frame) {
    // 解析StompFrame的body，根据错误内容做出决策
    // 这里是一个简单的示例，具体实现需要根据服务端的错误响应来决定
    if (frame.body != null) {
      print("=========================${frame.body}");
      // 假设服务端在某种错误时返回特定的错误信息
      if (frame.body!.contains("认证失败")) {
        return false; // 认证失败，不应该重新连接
      }
    }
    return true;
  }

  bool shouldReconnect(dynamic error) {
    // 基于错误类型或内容决定是否重新连接
    // 这里是一个简单的示例，实际应用中可能需要更复杂的逻辑
    return true;
  }

  void _onDisconnected(StompFrame frame) {
    connected = false;
    _retryCount++;
    print('Disconnected from WebSocket: ${frame.body}  ${_retryCount}  ${_maxRetry}');
    // 断开后，延时重连
    Future.delayed(Duration(seconds: 10 * _retryCount), () {
      // 递增的重连等待时间
      _connectWithRetry();
    });
  }

  void _onWebSocketError(dynamic error) {
    connected = false;
    print('WebSocketError from WebSocket: $error');
    // 根据错误类型，选择是否重新连接
    if (shouldReconnect(error)) {
      _retryCount++; // 重置重连尝试次数
      _connectWithRetry();
    } else {
      // 错误处理，比如更新UI通知用户错误信息
    }
  }

  void _onStompError(StompFrame frame) {
    connected = false;
    print('StompError : ${frame.headers} - ${frame.body} - ${frame.command}');
    // 依据错误内容做出决策，如是否重连
    if (shouldReconnectBasedOnStompError(frame)) {
      _retryCount ++; // 重置重连尝试次数
      _connectWithRetry();
    } else {
      // 其他错误处理，可能涉及到通知用户
    }
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
    // if (connected || _retryCount >= _maxRetry) {
    //   return; // 如果已经连接或重试次数达到限制，则不再尝试
    // }
    await ApiService().refreshToken();
    // 如果已有连接活跃，先断开
    if (_stompClient != null && _stompClient!.connected) {
      _stompClient!.deactivate();
      _stompClient = null;
    }
    var token = await ApiService().getToken();
    print("--------------------connectwithretry====================$token");
    if (token == null || token == '') {
      return;
    }
    if (ApiService().isTokenExpired(token)) {
      token = await ApiService().getToken();
      if (token == null || token == '') {
        return;
      }
    }
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://192.168.168.25:8081/chatserver',
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
