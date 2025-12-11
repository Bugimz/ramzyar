import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/password_entry.dart';
import 'encryption_service.dart';

/// سرویس دیتابیس برای ذخیره و مدیریت پسوردها
///
/// از الگوی Singleton استفاده می‌کند و پسوردها را به صورت
/// رمزنگاری شده ذخیره می‌کند.
class DbService {
  DbService._internal();
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;

  static const _databaseName = 'ramzyar.db';
  static const _tableName = 'passwords';

  Database? _db;
  final EncryptionService _encryption = EncryptionService();

  /// دسترسی به دیتابیس با lazy initialization
  Future<Database> get database async {
    if (_db != null) return _db!;
    await _encryption.initialize();
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

  /// دریافت تمام entries با رمزگشایی پسوردها
  Future<List<PasswordEntry>> fetchEntries() async {
    try {
      final db = await database;
      final maps = await db.query(_tableName, orderBy: 'createdAt DESC');
      return maps.map((m) {
        // رمزگشایی پسورد
        final decryptedPassword = _encryption.decrypt(m['password'] as String);
        return PasswordEntry.fromMap({...m, 'password': decryptedPassword});
      }).toList();
    } catch (e) {
      debugPrint('DbService.fetchEntries error: $e');
      return [];
    }
  }

  /// درج entry جدید با رمزنگاری پسورد
  Future<int> insertEntry(PasswordEntry entry) async {
    try {
      final db = await database;
      // رمزنگاری پسورد قبل از ذخیره
      final encryptedPassword = _encryption.encrypt(entry.password);
      final map = entry.toMap();
      map['password'] = encryptedPassword;
      return db.insert(_tableName, map);
    } catch (e) {
      debugPrint('DbService.insertEntry error: $e');
      return -1;
    }
  }

  /// به‌روزرسانی entry با رمزنگاری پسورد جدید
  Future<int> updateEntry(PasswordEntry entry) async {
    try {
      final db = await database;
      // رمزنگاری پسورد قبل از ذخیره
      final encryptedPassword = _encryption.encrypt(entry.password);
      final map = entry.toMap();
      map['password'] = encryptedPassword;
      return db.update(_tableName, map, where: 'id = ?', whereArgs: [entry.id]);
    } catch (e) {
      debugPrint('DbService.updateEntry error: $e');
      return -1;
    }
  }

  /// حذف entry
  Future<int> deleteEntry(int id) async {
    try {
      final db = await database;
      return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('DbService.deleteEntry error: $e');
      return -1;
    }
  }
}
