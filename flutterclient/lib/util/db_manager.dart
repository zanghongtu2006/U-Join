import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversation_id INTEGER,
    sender_id INTEGER,
    content TEXT,
    timestamp DATETIME,
    message_type TEXT,
    status TEXT,
    additional_info TEXT,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id),
    FOREIGN KEY (sender_id) REFERENCES users(id)
  );
  ''');

    await db.execute('''
  CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      full_name TEXT,
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
}
