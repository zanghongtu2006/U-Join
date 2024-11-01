import 'dart:async';
import 'dart:convert';

import 'package:flutterclient/page/chat_page/chat/ws_manager.dart';

import '../model/chat_model.dart';
import '../model/conversation_model.dart';
import '../model/user_model.dart';
import '../../../util/chat_util.dart';
import '../../../util/db_manager.dart';

class MessageUtil {
  final Map<String, Timer> _timers = {};
  static final MessageUtil _instance = MessageUtil._internal();
  MessageUtil._internal();
  static MessageUtil get instance => _instance;

  Future<bool> sendMessage(Message message) async {
    String destination = '/app/chat';
    await insertOrUpdate(message);
    return WsManager().sendMessage(destination, jsonEncode(message.toSendMap()));
  }

  static Future<void> insertOrUpdate(Message message) async {
    await DatabaseManager.instance.insertOrUpdateMessage(message);
    Conversation conversation = await DatabaseManager.instance.findConversationById(message.conversationId);
    conversation.lastMessage = message.content.text;
    await DatabaseManager.instance.insertOrUpdateConversation(conversation);
  }

  void putMessageTimers(Message chatModel) {
    _timers[chatModel.messageId] = Timer(const Duration(seconds: 10), () {
      _setMessageFailed(chatModel);
    });
  }

  Future<void> _setMessageFailed(Message chatModel) async {
    chatModel.sendStatus = 'FAILED';
    await DatabaseManager.instance.insertOrUpdateMessage(chatModel);
    _timers[chatModel.messageId]?.cancel();
    _timers.remove(chatModel.messageId);
  }

  void _removeMessageTimers(String messageId) {
    _timers[messageId]?.cancel();
    _timers.remove(messageId);
  }

  Future<Message?> dealReceived(String msg, String myUid) async {
    Map<String, dynamic> messageData = json.decode(msg);
    if (messageData['messageType'] == 'CHAT_REPLY') {
      String replyToMessageId = messageData['additionalInfo']['replyToMessageId'];
      Message message = await DatabaseManager.instance.findMessagesById(replyToMessageId);
      message.sendStatus = 'SUCCESS';
      DatabaseManager.instance.insertOrUpdateMessage(message);
      Conversation conversation = await DatabaseManager.instance.findConversationById(messageData['conversationId']);
      conversation.lastMessage = message.content.text;
      DatabaseManager.instance.insertOrUpdateConversation(conversation);
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
      final message = Message(
        messageId: messageData['messageId'],
        conversationId: messageData['conversationId'],
        shortConversationId: messageData['shortConversationId'],
        isMe: isMe,
        senderId: messageData['senderId'],
        content: Content(
          type: messageData['content']['type'],
          text: messageData['content']['text'],
          filePath: messageData['content']['filePath'],
          fileUrl: messageData['content']['fileUrl'],
          duration: messageData['content']['duration'],
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
      DatabaseManager.instance.insertOrUpdateMessage(message);
      DatabaseManager.instance.insertOrUpdateConversation(conversation);
      _removeMessageTimers(messageData['messageId']);
      if(!isMe) {
        return message;
      }
    }
    return null;
  }

  Message buildSendingMessage(String conversationId, String shortConversationId, User sender,
      String conentType, String contentText, String filePath, String fileUrl, int duration) {
    // 生成消息ID
    String messageId = ChatUtils.generateMessageId(shortConversationId);
    final message = Message(
      messageId: messageId,
      conversationId: conversationId,
      shortConversationId: shortConversationId,
      isMe: true,
      senderId: sender.id,
      sender: User(
        id: sender.id,
        nickName: sender.nickName,
        avatar: sender.avatar,
        gender: sender.gender,
      ),
      content: Content(
        type: conentType,
        text: contentText,
        filePath: filePath,
        fileUrl: fileUrl,
        duration: duration,
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
    return message;
  }
}
