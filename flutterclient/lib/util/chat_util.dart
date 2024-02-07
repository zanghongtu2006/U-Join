import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ChatUtils {
  static String generateConversationId(List<String> participantIds) {
    // 确保ID列表是排序的，以保持一致性
    participantIds.sort();
    // 将ID连接成字符串，使用特定分隔符
    var concatenatedIds = participantIds.join("-");
    // 使用SHA256哈希算法来生成唯一的conversationId
    var bytes = utf8.encode(concatenatedIds);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String generateMessageId(String userId) {
    // 获取当前时间戳
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // 获取用户ID的简短形式，这里假设取前6位
    var shortUserId = userId.length > 6 ? userId.substring(0, 6) : userId;
    // 生成一个随机字符串
    var randomString = _generateRandomString(4);
    // 拼接字符串
    return "$timestamp-$shortUserId-$randomString";
  }

  // 生成随机字符串的私有方法
  static String _generateRandomString(int length) {
    const _chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
