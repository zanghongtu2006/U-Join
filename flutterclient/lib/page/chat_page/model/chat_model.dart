import 'dart:convert';

import 'package:flutterclient/page/chat_page/model/user_model.dart';

class ChatModel {
  late String messageId;
  final String conversationId;
  final String shortConversationId;
  final bool isMe;
  final String senderId;
  late User? sender;
  late User? receiver;
  final Content content;
  late DateTime timestamp;
  final String messageType;
  late Status status;
  late String sendStatus; //SENDING,SUCCESS,FAILED
  final AdditionalInfo additionalInfo;

  ChatModel({
    required this.messageId,
    required this.isMe,
    required this.senderId,
    this.sender,
    required this.conversationId,
    required this.shortConversationId,
    this.receiver,
    required this.content,
    required this.timestamp,
    required this.messageType,
    required this.status,
    required this.sendStatus,
    required this.additionalInfo,
  });

  Map<String, dynamic> toSendMap() {
    return {
      'messageId': messageId,
      'conversationId': conversationId,
      'shortConversationId': shortConversationId,
      'isMe': isMe ? 1 : 0,
      'senderId': senderId,
      'receiverId': receiver?.id,
      'content': content.toMap(), // 序列化为JSON字符串
      'timestamp': timestamp.millisecondsSinceEpoch,
      'messageType': messageType,
      'status': status.toSendMap(), // 假设Status也适用toMap
      'additionalInfo': additionalInfo.toMap(), // 同上
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'conversationId': conversationId,
      'shortConversationId': shortConversationId,
      'isMe': isMe ? 1 : 0,
      'senderId': senderId,
      'receiverId': receiver?.id,
      'content': jsonEncode(content.toMap()), // 序列化为JSON字符串
      'timestamp': timestamp.toIso8601String(),
      'messageType': messageType,
      'status': jsonEncode(status.toMap()), // 假设Status也适用toMap
      'sendStatus': sendStatus, // 假设Status也适用toMap
      'additionalInfo': jsonEncode(additionalInfo.toMap()), // 同上
    };
  }

  static ChatModel fromMap(Map<String, dynamic> map) {
    return ChatModel(
      messageId: map['messageId'],
      conversationId: map['conversationId'],
      shortConversationId: map['shortConversationId'],
      isMe: map['isMe'] == 1,
      senderId: map['senderId'] ?? '',
      // sender: map['sender'] != null ? User.fromMap(map['sender']) : null, // 需要处理User.fromMap
      receiver: map['receiver'] != null ? User.fromMap(map['receiver']) : null,
      content: Content.fromMap(jsonDecode(map['content'])),
      // 从JSON字符串反序列化
      timestamp: DateTime.parse(map['timestamp']),
      messageType: map['messageType'],
      status: Status.fromMap(jsonDecode(map['status'])),
      sendStatus: map['sendStatus'] ?? 'FAILED',
      // 需要处理Status.fromMap
      additionalInfo:
          AdditionalInfo.fromMap(jsonDecode(map['additionalInfo'])), // 同上
    );
  }
}

class Content {
  final String type;
  final String text;

  Content({required this.type, required this.text});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'text': text,
    };
  }

  static Content fromMap(Map<String, dynamic> map) {
    return Content(
      type: map['type'],
      text: map['text'],
    );
  }
}

class Status {
  final bool read;
  final DateTime sendTime;

  Status({required this.read, required this.sendTime});

  Map<String, dynamic> toMap() {
    return {
      'read': read ? 1 : 0,
      'sendTime': sendTime.toIso8601String(),
    };
  }

  Map<String, dynamic> toSendMap() {
    return {
      'read': read ? 1 : 0,
      'sendTime': sendTime.millisecondsSinceEpoch,
    };
  }

  static Status fromMap(Map<String, dynamic> map) {
    return Status(
      read: map['read'] == 1,
      sendTime: DateTime.parse(map['sendTime']),
    );
  }
}

class AdditionalInfo {
  final String replyToMessageId;

  AdditionalInfo({required this.replyToMessageId});

  Map<String, dynamic> toMap() {
    return {
      'replyToMessageId': replyToMessageId,
    };
  }

  static AdditionalInfo fromMap(Map<String, dynamic> map) {
    return AdditionalInfo(
      replyToMessageId: map['replyToMessageId'],
    );
  }
}
