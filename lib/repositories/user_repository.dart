import 'package:flutter_application_1/models/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);

  Future<User?> getUser(String email);

  Future<List<User>> getAllUsers();

  Future<void> updateUser(User user);

  Future<void> deleteUser(String email);

  Future<void> setCurrentUserEmail(String? email);

  Future<User?> getCurrentUser();

  Future<void> clearCurrentUser();
}
