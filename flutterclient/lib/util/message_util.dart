import 'dart:async';
import 'dart:convert';

import 'package:flutterclient/util/ws_service.dart';

import '../page/chat_page/model/chat_model.dart';
import '../page/chat_page/model/conversation_model.dart';
import 'db_manager.dart';

class MessageUtil {
  final Map<String, Timer> _timers = {};
  static final MessageUtil _instance = MessageUtil._internal();
  MessageUtil._internal();
  static MessageUtil get instance => _instance;

  Future<bool> sendMessage(ChatModel chatModel) async {
    String destination = '/app/chat';
    await DatabaseManager.instance.insertMessage(chatModel);
    return ChatService().sendMessage(destination, jsonEncode(chatModel.toSendMap()));
  }

  void putMessageTimers(ChatModel chatModel) {
    _timers[chatModel.messageId] = Timer(const Duration(seconds: 15), () {
      _setMessageFailed(chatModel);
    });
  }

  Future<void> _setMessageFailed(ChatModel chatModel) async {
    chatModel.sendStatus = 'FAILED';
    await DatabaseManager.instance.insertMessage(chatModel);
    _timers[chatModel.messageId]?.cancel();
    _timers.remove(chatModel.messageId);
  }

  void removeMessageTimers(String messageId) {
    _removeMessageTimers(messageId);
  }

  void _removeMessageTimers(String messageId) {
    _timers[messageId]?.cancel();
    _timers.remove(messageId);
  }

  Future<ChatModel?> dealReceived(String msg, String myUid) async {
    Map<String, dynamic> messageData = json.decode(msg);
    if (messageData['messageType'] == 'CHAT_REPLY') {
      String replyToMessageId = messageData['additionalInfo']['replyToMessageId'];
      ChatModel message = await DatabaseManager.instance.findMessagesById(replyToMessageId);
      message.sendStatus = 'SUCCESS';
      DatabaseManager.instance.insertMessage(message);
      _removeMessageTimers(replyToMessageId);
      return message;
    } else if (messageData['messageType'] == 'CHAT') {
      bool isMe = messageData['senderId'] == myUid;
      String sendStatus = "RECEIVED";
      Status status;
      if(isMe) {
        sendStatus = "SUCCESS";
        status = Status(
          read: true,
          sendTime: DateTime.fromMillisecondsSinceEpoch(messageData['timestamp'])
        );
      } else {
        status = Status(
          read: false,
          sendTime: DateTime.fromMillisecondsSinceEpoch(messageData['timestamp'])
        );
      }
      final message = ChatModel(
        messageId: messageData['messageId'],
        conversationId: messageData['conversationId'],
        shortConversationId: messageData['shortConversationId'],
        isMe: isMe,
        senderId: messageData['senderId'],
        content: Content(
          type: messageData['content']['type'],
          text: messageData['content']['text'],
        ),
        timestamp: DateTime.fromMillisecondsSinceEpoch(messageData['timestamp']),
        messageType: messageData['messageType'],
        status: status,
        sendStatus: sendStatus,
        additionalInfo: AdditionalInfo(
          replyToMessageId: messageData['additionalInfo']['replyToMessageId'],
        ),
      );
      Conversation conversation = await DatabaseManager.instance.findConversationById(messageData['conversationId']);
      conversation.lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(messageData['timestamp']);
      conversation.lastMessage = messageData['content']['text'];
      conversation.unReadCount = conversation.unReadCount+1;
      DatabaseManager.instance.insertMessage(message);
      DatabaseManager.instance.insertConversation(conversation);
      _removeMessageTimers(messageData['messageId']);
      return message;
    }
    return null;
  }
}
