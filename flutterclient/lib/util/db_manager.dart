import 'package:flutterclient/util/api_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../page/chat_page/model/chat_model.dart';
import '../page/chat_page/model/conversation_model.dart';
import '../page/chat_page/model/user_model.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();

  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String userId = await ApiService().getUid();
    final filePath = 'chat_$userId.db';
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE conversations (
    conversationId TEXT PRIMARY KEY,
    shortConversationId TEXT,
    nickName TEXT,
    avatar TEXT,
    type TEXT,
    unReadCount INTEGER,
    gender TEXT,
    userIds TEXT,
    lastMessage TEXT,
    lastUpdateTime DATETIME
  );
  ''');
    await db.execute('''
  CREATE TABLE messages (
    messageId TEXT PRIMARY KEY,
    conversationId TEXT,
    shortConversationId TEXT,
    isMe INTEGER,
    senderId TEXT,
    receiverId TEXT,
    content TEXT,
    timestamp TEXT,
    messageType TEXT,
    status TEXT,
    sendStatus TEXT,
    additionalInfo TEXT
    );
  ''');

    await db.execute('''
  CREATE TABLE users (
    id TEXT PRIMARY KEY,
    nickName TEXT,
    avatar TEXT,
    gender TEXT,
    height int
  );
  ''');

    await db.execute('''
  CREATE TABLE groups (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      avatar TEXT
  );
  ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  //Message
  Future<void> insertOrUpdateMessage(Message chatModel) async {
    final db = await instance.database;
    await db.insert(
      'messages',
      chatModel.toMap(), // 假设您有一个方法将ChatModel转换为Map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Message> findMessagesById(String messageId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'messageId = ?',
      whereArgs: [messageId]
    );

    // 将查询结果的每个Map转换为ChatModel
    return List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    }).reversed.toList().first; // 确保消息按时间升序排列
  }

  Future<List<Message>> findMessagesByConversationId(String conversationId, int offset) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      orderBy: 'messageId DESC',
      limit: 20,
      offset: offset
    );

    // 将查询结果的每个Map转换为ChatModel
    return List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    }).reversed.toList(); // 确保消息按时间升序排列
  }

  Future<void> deleteMessage(String messageId) async {
    final db = await instance.database;
    await db.delete(
      'messages',
      where: 'messageId = ?',
      whereArgs: [messageId],
    );
  }

  //user
  Future<List<User>> findUsersByIds(List<String> ids) async {
    final db = await instance.database;
    // 将ID列表转换为适合SQL查询的字符串形式
    String inClause = ids.map((id) => '?').join(',');
    // 执行查询
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id IN ($inClause)',
      whereArgs: ids,
    );

    // 将查询结果转换为User列表
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<User> fetchUserById(String userId) async {
    final db = await DatabaseManager.instance.database;
    final maps = await db.query(
      'users',
      columns: ['id', 'nickName', 'avatar', 'gender'],
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      throw Exception('User ID $userId not found');
    }
  }

  Future<void> insertOrUpdateUsers(List<User> users) async {
    final db = await instance.database;
    for (var user in users) {
      await db.insert(
        'users',
        user.toDBMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // 使用REPLACE策略
      );
    }
  }

  //Conversations
  Future<void> insertOrUpdateConversation(Conversation conversation) async {
    final db = await instance.database;
    Map<String, dynamic> conversationMap = await conversation.toMap();
    await db.insert(
      'conversations',
      conversationMap, // 假设您有一个方法将ChatModel转换为Map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertOrUpdateConversations(List<Conversation> conversations) async {
    for (var conversation in conversations) {
      await insertOrUpdateConversation(conversation);
    }
  }

  Future<List<Conversation>> listConversations(int offset, int limit, String ownerId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'conversations',
      where: 'ownerId = ?', // 使用ownerId作为查询条件
      whereArgs: [ownerId], // 参数化查询，防止SQL注入
      orderBy: 'lastUpdateTime DESC',
      limit: limit,
      offset: offset,
    );

    // 将查询结果的每个Map转换为ChatModel
    return List.generate(maps.length, (i) {
      return Conversation.fromDB(maps[i]);
    }).reversed.toList(); // 确保消息按时间升序排列
  }

  Future<Conversation> findConversationById(String conversationId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        'conversations',
        where: 'conversationId = ?',
        whereArgs: [conversationId]
    );

    // 将查询结果的每个Map转换为ChatModel
    return List.generate(maps.length, (i) {
      return Conversation.fromDB(maps[i]);
    }).reversed.toList().first; // 确保消息按时间升序排列
  }

  Future<void> deleteConversation(String conversationId) async {
    final db = await instance.database;
    await db.delete(
      'conversations',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
    );
  }
}
