import 'dart:async';
import 'dart:ui';

import '../../../util/chat_util.dart';
import '../../../util/db_manager.dart';
import '../model/chat_model.dart';
import 'message_util.dart';

typedef SendMessageCallback = void Function(Message message);
typedef SendFileMessageCallback = void Function();

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();
  static ChatService get instance => _instance;

  void sendMessage(Message message, SendMessageCallback onMessageSent) async {
    bool sendResult = await MessageUtil.instance.sendMessage(message);
    if (!sendResult) {
      message.sendStatus = 'FAILED';
      await DatabaseManager.instance.insertMessage(message);
    } else {
      MessageUtil.instance.putMessageTimers(message);
      onMessageSent(message);
    }
  }

  void sendFileMessage(Message message, SendFileMessageCallback onMessageSent) async {
    bool sendResult = await MessageUtil.instance.sendMessage(message);
    if (!sendResult) {
      message.sendStatus = 'FAILED';
      await DatabaseManager.instance.insertMessage(message);
    } else {
      MessageUtil.instance.putMessageTimers(message);
      onMessageSent();
    }
  }

  void retrySendMessage(Message message, String shortConversationId, SendMessageCallback onMessageSent) async {
    await DatabaseManager.instance.deleteMessage(message.messageId);
    String messageId = ChatUtils.generateMessageId(shortConversationId);
    message.messageId = messageId;
    message.timestamp = DateTime.now();
    message.status = Status(
      read: true,
      sendTime: message.timestamp,
    );
    message.sendStatus = "SENDING";
    sendMessage(message, onMessageSent);
  }

}