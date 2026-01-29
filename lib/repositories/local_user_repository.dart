import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/repositories/user_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalUserRepository implements UserRepository {
  static const _usersBox = 'users_box';
  static const _metaBox = 'meta_box';
  static const _currentUserKey = 'current_user_email';

  const LocalUserRepository();

  Box<dynamic> get _users => Hive.box<dynamic>(_usersBox);
  Box<dynamic> get _meta => Hive.box<dynamic>(_metaBox);

  @override
  Future<void> createUser(User user) async {
    await _users.put(user.email, user.toJson());
  }

  @override
  Future<void> deleteUser(String email) async {
    await _users.delete(email);
    final cur = _meta.get(_currentUserKey) as String?;
    if (cur == email) {
      await _meta.delete(_currentUserKey);
    }
  }

  @override
  Future<User?> getUser(String email) async {
    final raw = _users.get(email);
    if (raw == null) return null;
    final parsed = Map<String, dynamic>.from(raw as Map);
    return User.fromJson(parsed);
  }

  @override
  Future<List<User>> getAllUsers() async {
    final list = <User>[];
    for (final v in _users.values) {
      final parsed = Map<String, dynamic>.from(v as Map);
      list.add(User.fromJson(parsed));
    }
    return list;
  }

  @override
  Future<void> updateUser(User user) async {
    await _users.put(user.email, user.toJson());
  }

  @override
  Future<void> setCurrentUserEmail(String? email) async {
    if (email == null) {
      await _meta.delete(_currentUserKey);
    } else {
      await _meta.put(_currentUserKey, email);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final email = _meta.get(_currentUserKey) as String?;
    if (email == null) return null;
    return getUser(email);
  }

  @override
  Future<void> clearCurrentUser() async {
    await _meta.delete(_currentUserKey);
  }
}
