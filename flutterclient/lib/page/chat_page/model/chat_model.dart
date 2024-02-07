class ChatModel {
  late String messageId;
  late User sender;
  late User recver;
  late Content content;
  late DateTime timestamp;
  late String messageType;
  late Status status;
  late AdditionalInfo additionalInfo;
}

class User {
  late String id;
  late String fullName;
  late String avatar;
}

class Content {
  late String type;
  late String text;
}

class Status {
  late bool read;
  late DateTime sendTime;
}

class AdditionalInfo {
  late String replayToMessageId;
}
