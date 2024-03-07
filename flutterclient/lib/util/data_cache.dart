import 'dart:convert';

import '../page/chat_page/model/conversation_model.dart';
import '../page/chat_page/model/user_model.dart';
import 'api_service.dart';
import 'db_manager.dart';

class DataCache {
  Future<List<User>> fetchUserData(List<String> userIds) async {
    List<User> users = await DatabaseManager.instance.findUsersByIds(userIds);
    if (users.length == userIds.length) {
      return users;
    }
    var combinedIds = userIds.join(',');
    try {
      final Map<String, String> params = {'id': combinedIds};
      var response = await ApiService().get("/users", params: params);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        users = List<User>.from(data.map((item) => User.fromMap(item)));
        DatabaseManager.instance.insertOrUpdateUsers(users);
      }
    } catch (e) {
      print(e);
    }
    return users;
  }

  Future<List<Conversation>> fetchConversations(int page, int pageSize) async {
    List<Conversation> conversations = [];
    try {
      var response = await ApiService().get("/conversations/latest");
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data']['rows'];
        conversations = List<Conversation>.from(
            data.map((item) => Conversation.fromMap(item)));
        DatabaseManager.instance.insertOrUpdateConversations(conversations);
      }
    } catch (e) {
      print("fetchConversations===$e");
    }
    // fetch from db
    int offset = (page - 1) * pageSize;
    conversations = await DatabaseManager.instance.listConversations(offset, pageSize);
    return conversations;
  }
}
