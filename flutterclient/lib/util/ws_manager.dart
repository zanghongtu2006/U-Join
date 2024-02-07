// // WebSocketManager.dart
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// class WebSocketManager {
//   static final WebSocketManager _instance = WebSocketManager._internal();
//
//   factory WebSocketManager() {
//     return _instance;
//   }
//
//   WebSocketManager._internal();
//
//   late WebSocketChannel _channel;
//   bool _isConnected = false;
//
//   void connect(String url) {
//     if (!_isConnected) {
//       _channel = WebSocketChannel.connect(Uri.parse(url));
//       _isConnected = true;
//       // 监听消息
//       _channel.stream.listen((message) {
//         // 处理接收到的消息
//         print(message);
//       });
//     }
//   }
//
//   void disconnect() {
//     if (_isConnected) {
//       _channel.sink.close();
//       _isConnected = false;
//     }
//   }
//
//   void sendMessage(String message) {
//     if (_isConnected) {
//       _channel.sink.add(message);
//     }
//   }
// }
