import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/password_entry.dart';

class DbService {
  DbService._internal();
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;

  static const _databaseName = 'ramzyar.db';
  static const _tableName = 'passwords';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            website TEXT,
            notes TEXT,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<PasswordEntry>> fetchEntries() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'createdAt DESC');
    return maps.map((m) => PasswordEntry.fromMap(m)).toList();
  }

  Future<int> insertEntry(PasswordEntry entry) async {
    final db = await database;
    return db.insert(_tableName, entry.toMap());
  }

  Future<int> updateEntry(PasswordEntry entry) async {
    final db = await database;
    return db.update(
      _tableName,
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    return db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
