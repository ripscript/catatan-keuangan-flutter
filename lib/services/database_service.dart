// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DatabaseService {
  late Database _database;

  Future<void> initDatabase() async {
    print('init database');
    _database = await openDatabase(
      join(await getDatabasesPath(), 'sqlite.db'),
      onCreate: (db, version) {
        print('oncreate');
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, is_android INTEGER, intro INTEGER, device_name TEXT);'
          'CREATE TABLE financial_recaps(id INTEGER PRIMARY KEY, title TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> deleteAllUsers() async {
    await initDatabase();
    await _database.delete('users');
    print('Berhasil menghapus semua user');
  }

  Future<void> insertUser(User user) async {
    await initDatabase();
    await _database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO users(is_android, intro, device_name) VALUES(?, ?, ?)',
          [user.isAndroid, user.intro, user.deviceName]);
      print('Berhasil menambah user');
    });
  }

  Future<List<User>> getUsers() async {
    await initDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<User?> getUserLogin() async {
    await initDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('users');
    if (maps.isNotEmpty) {
      return User.fromMap(maps[0]);
    }
    return null;
  }

  Future<void> updateUserLogin(int id, bool intro) async {
    await initDatabase();
    await _database.update('users', {'intro': intro},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAppDatabase() async {
    await deleteDatabase(join(await getDatabasesPath(), 'sqlite.db'));
    print('Berhasil menghapus database');
  }

  // Future<void> deleteUser(int id) async {
  //   await initDatabase();
  //   await _database.delete('users', where: 'id = ?', whereArgs: [id]);
  // }
}
