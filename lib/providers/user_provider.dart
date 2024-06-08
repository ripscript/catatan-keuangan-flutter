// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class UserProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<User> _users = [];

  Future<List<User>> get users async {
    await fetchUsers();
    return _users;
  }

  Future<void> fetchUsers() async {
    _users = await _databaseService.getUsers();
    notifyListeners();
  }

  Future<User?> getUserLogin() async {
    return await _databaseService.getUserLogin();
  }

  Future updateUserLogin(int id, bool intro) async {
    await _databaseService.updateUserLogin(id, intro);
  }

  Future<void> deleteAllUsers() async {
    await _databaseService.deleteAllUsers();
    _users = [];
    notifyListeners();
  }

  Future<void> addUser(bool isAndroid, bool intro, String deviceName) async {
    final newUser = User(
      isAndroid: isAndroid,
      intro: intro,
      deviceName: deviceName,
    );

    await _databaseService.insertUser(newUser).then((value) {
      notifyListeners();
    });
  }
}
