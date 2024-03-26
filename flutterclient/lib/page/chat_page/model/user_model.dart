class User {
  late String id;
  late String nickName;
  late String avatar;
  late String gender;
  late int age;
  late int height;
  late String job;

  User({required this.id, required this.nickName, required this.avatar,
    required this.gender, this.height=160, this.age=18, this.job='其它'});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickName': nickName,
      'avatar': avatar,
      'gender': gender,
      'height': height,
      'job': job,
      'age': age,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nickName: map['nickName'],
      avatar: map['avatar'],
      age: map['age']??18,
      gender: map['gender'],
      height: map['height']??160,
      job: map['job']??'其它',
    );
  }

  Map<String, dynamic> toDBMap() {
    return {
      'id': id,
      'nickName': nickName,
      'avatar': avatar,
      'gender': gender,
    };
  }

  static User fromDBMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nickName: map['nickName'],
      avatar: map['avatar'],
      gender: map['gender'],
    );
  }
}
