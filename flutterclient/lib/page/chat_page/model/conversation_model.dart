class Conversation {
  final String conversationId;

  final String shortConversationId;

  final String nickName;

  final String avatar;

  final String type;

  late String lastMessage;

  late int unReadCount;

  final List<String> userIds;

  final String gender;
  late DateTime lastUpdateTime;

  Conversation({
    required this.conversationId,
    required this.shortConversationId,
    required this.nickName,
    required this.type,
    required this.avatar,
    required this.lastMessage,
    required this.userIds,
    required this.unReadCount,
    required this.gender,
    required this.lastUpdateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'shortConversationId': shortConversationId,
      'nickName': nickName,
      'type': type,
      'unReadCount': unReadCount,
      'avatar': avatar,
      'lastMessage': lastMessage,
      'userIds': userIds.join(","),
      'lastUpdateTime': lastUpdateTime.toIso8601String(),
    };
  }

  static Conversation fromMap(Map<String, dynamic> map) {
    print(map);
    return Conversation(
      conversationId: map['conversationId'],
      shortConversationId: map['shortConversationId'],
      nickName: map['nickName'],
      type: map['type'],
      unReadCount: map['unReadCount']??0,
      avatar: map['avatar'],
      gender: map['gender']??'UNKNOWN',
      userIds: List<String>.from(map['userIds']),
      lastMessage: map['lastMessage'],
      lastUpdateTime: DateTime.parse(
          map['lastUpdateTime'] ?? DateTime.now().toIso8601String()),
    );
  }

  static Conversation fromDB(Map<String, dynamic> map) {
    return Conversation(
      conversationId: map['conversationId'],
      shortConversationId: map['shortConversationId'],
      nickName: map['nickName'],
      type: map['type'],
      unReadCount: map['unReadCount'],
      avatar: map['avatar'],
      gender: map['gender'] ?? 'UNKNOWN',
      userIds: List<String>.from(map['userIds'].split(',')),
      lastMessage: map['lastMessage'],
      lastUpdateTime: DateTime.parse(
          map['lastUpdateTime'] ?? DateTime.now().toIso8601String()),
    );
  }
}
