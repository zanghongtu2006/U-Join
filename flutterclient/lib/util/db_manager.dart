import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../page/chat_page/model/chat_model.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();

  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE conversations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    target_id INTEGER,
    last_message_timestamp DATETIME
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
    avatar TEXT
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

  Future<void> insertMessage(ChatModel chatModel) async {
    final db = await instance.database;
    await db.insert(
      'messages',
      chatModel.toMap(), // 假设您有一个方法将ChatModel转换为Map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ChatModel> findMessagesById(String messageId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'messageId = ?',
      whereArgs: [messageId]
    );

    // 将查询结果的每个Map转换为ChatModel
    return List.generate(maps.length, (i) {
      return ChatModel.fromMap(maps[i]);
    }).reversed.toList().first; // 确保消息按时间升序排列
  }

  Future<List<ChatModel>> findMessagesByConversationId(String conversationId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      orderBy: 'messageId DESC',
      limit: 50,
    );

    // 将查询结果的每个Map转换为ChatModel
    return List.generate(maps.length, (i) {
      return ChatModel.fromMap(maps[i]);
    }).reversed.toList(); // 确保消息按时间升序排列
  }

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
      columns: ['id', 'nickName', 'avatar'],
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
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // 使用REPLACE策略
      );
    }
  }

  Future<void> deleteMessage(String messageId) async {
    final db = await instance.database;
    await db.delete(
      'messages',
      where: 'messageId = ?',
      whereArgs: [messageId],
    );
  }

}
