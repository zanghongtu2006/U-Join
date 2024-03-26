import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutterclient/util/api_service.dart';

class ChatUtils {
  static Future<String?> generateConversationIdByUser(String userId) async {
    String? myUid = await ApiService().getUid();
    if (myUid != null) {
      List<String> participantIds = [userId, myUid];
      return generateConversationId(participantIds);
    }
    return null;
  }

  static String generateConversationId(List<String> participantIds) {
    String id1 = participantIds[0].replaceAll("-", "");
    String id2 = participantIds[1].replaceAll("-", "");
    if (id1.compareTo(id2) < 0) {
      return "$id1$id2";
    } else {
      return "$id2$id1";
    }
  }

  static String generateMessageId(String shortConversationId) {
    // 获取当前时间戳
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    // 获取用户ID的简短形式，这里假设取前6位
    // 生成一个随机字符串
    var randomString = _generateRandomString(4);
    // 拼接字符串
    return "$timestamp-$shortConversationId-$randomString";
  }

  // 生成随机字符串的私有方法
  static String _generateRandomString(int length) {
    const _chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
