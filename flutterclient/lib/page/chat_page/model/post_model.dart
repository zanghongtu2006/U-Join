import 'user_model.dart';

class Post {
  late String id;
  late User userInfo;
  late String content;
  late List<String> imageUrls;
  late String videoUrl;
  late String audioUrl;
  late int likeCount;
  late int replyCount;
  late String location;
  late DateTime createTime;
  late bool like;

  Post({
    required this.id,
    required this.userInfo,
    required this.content,
    required this.imageUrls,
    required this.videoUrl,
    required this.audioUrl,
    required this.likeCount,
    required this.replyCount,
    required this.location,
    required this.createTime,
    required this.like,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userInfo': userInfo,
      'content': content,
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'likeCount': likeCount,
      'replyCount': replyCount,
      'location': location,
      'createTime': createTime,
    };
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userInfo: User.fromMap(map['userInfo']),
      content: map['content'],
      imageUrls: map['imageUrls']?.whereType<String>().toList()??[],
      videoUrl: map['videoUrl']??'',
      audioUrl: map['audioUrl']??'',
      like: map['like']??false,
      likeCount: map['likeCount'],
      replyCount: map['replyCount'],
      location: map['location']??'未知',
      createTime: DateTime.parse(
          map['createTime'] ?? DateTime.now().toIso8601String()),
    );
  }
}