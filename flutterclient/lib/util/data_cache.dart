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

  Future<void> _fetchConversaionsFromServer(int page, int pageSize) async {
    try {
      var response = await ApiService().get("/conversations/latest");
      String ownerId = await ApiService().getUid();
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data']['rows'];
        List<Conversation> conversations = List<Conversation>.from(data.map((item) => Conversation.fromMap(item, ownerId)));
        DatabaseManager.instance.insertOrUpdateConversations(conversations);
      }
    } catch (e) {
      print("fetchConversations===$e");
    }
  }

  Future<List<Conversation>> fetchConversations(int page, int pageSize) async {
    List<Conversation> conversations = [];
    _fetchConversaionsFromServer(page, pageSize);
    // fetch from db
    int offset = (page - 1) * pageSize;
    String ownerId = await ApiService().getUid();
    conversations = await DatabaseManager.instance.listConversations(offset, pageSize, ownerId);
    return conversations;
  }
}
