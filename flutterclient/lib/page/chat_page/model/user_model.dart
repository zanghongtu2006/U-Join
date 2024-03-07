class User {
  final String id;
  final String nickName;
  final String avatar;
  final String gender;

  User({required this.id, required this.nickName, required this.avatar, required this.gender});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickName': nickName,
      'avatar': avatar,
      'gender': gender,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nickName: map['nickName'],
      avatar: map['avatar'],
      gender: map['gender'],
    );
  }
}
