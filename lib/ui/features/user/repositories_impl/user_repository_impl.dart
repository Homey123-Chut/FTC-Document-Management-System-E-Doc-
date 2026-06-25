import 'dart:convert';

import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/data/repositories/user/user_repository.dart';
import 'package:flutter/services.dart';

class MockUserRepository implements UserRepository {
  static const _assetPath = 'lib/data/mock_data/user.json';

  List<UserModel>? _cachedUsers;
  bool _loaded = false;

  Future<List<UserModel>> _loadUsers() async {
    if (_loaded && _cachedUsers != null) return _cachedUsers!;

    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final usersList = decoded['users'] as List<dynamic>? ?? [];

    _cachedUsers = usersList
        .map((u) => UserModel.fromJson(Map<String, dynamic>.from(u as Map)))
        .toList();
    _loaded = true;
    return _cachedUsers!;
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    final users = await _loadUsers();
    final normalizedEmail = email.trim().toLowerCase();

    for (final user in users) {
      if (user.email.toLowerCase() == normalizedEmail &&
          user.password == password) {
        return user.copyWith(password: '');
      }
    }
    return null;
  }

  @override
  Future<List<UserModel>> fetchAllUsers() async {
    final users = await _loadUsers();
    return users.map((u) => u.copyWith(password: '')).toList();
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    final users = await _loadUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel?> updateUser(UserModel updated) async {
    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.id == updated.id);
    if (index == -1) return null;

    _cachedUsers![index] = updated;
    return updated.copyWith(password: '');
  }

  @override
  Future<bool> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.id == userId);
    if (index == -1) return false;

    final user = users[index];
    if (user.password != oldPassword) return false;

    _cachedUsers![index] = user.copyWith(password: newPassword);
    return true;
  }

  @override
  Future<String?> uploadProfileImage(String userId, String filePath) async {
    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.id == userId);
    if (index == -1) return null;

    // In a real app, this would upload to a server and return a URL.
    // For the mock, store the file path directly as the profile image.
    _cachedUsers![index] = _cachedUsers![index].copyWith(profileImg: filePath);
    return filePath;
  }
}
