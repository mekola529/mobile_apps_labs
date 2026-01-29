import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/repositories/user_repository.dart';

class AuthResult {
  final bool success;
  final String? message;
  final User? user;

  const AuthResult.success([this.user]) : success = true, message = null;

  const AuthResult.failure(this.message) : success = false, user = null;
}

class AuthService {
  final UserRepository repository;

  const AuthService({required this.repository});

  Future<AuthResult> register(
    {
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }
  ) async {
    final err = _validateRegistration(
      name,
      email,
      password,
      confirmPassword,
    );

    if (err != null) return AuthResult.failure(err);

    final existing = await repository.getUser(email);
    if (existing != null) {
      return const AuthResult.failure(
        'Користувач з таким email вже існує',
      );
    }

    // check login uniqueness
    final all = await repository.getAllUsers();
    for (final u in all) {
      if (u.name.toLowerCase() == name.trim().toLowerCase()) {
        return const AuthResult.failure('Логін вже використовується');
      }
    }

    final user = User(
      name: name.trim(),
      email: email.trim(),
      password: password,
    );

    await repository.createUser(user);
    return const AuthResult.success();
  }

  String? _validateRegistration(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) {
    final login = name.trim();
    if (login.isEmpty) return 'Логін не може бути пустим';
    if (login.contains(' ')) return 'Логін не повинен містити пробілів';
    if (!email.contains('@')) return 'Невірний email';
    if (password.length < 8) return 'Пароль має бути щонайменше 8 символів';
    if (password != confirmPassword) return 'Паролі не збігаються';
    return null;
  }

  Future<AuthResult> login(
    {required String login, required String password}
  ) async {
    if (login.contains(' ')) {
      return const AuthResult.failure('Логін не може містити пробілів');
    }

    final key = login.trim();
    // try as email first
    var user = await repository.getUser(key);

    if (user == null) {
      final all = await repository.getAllUsers();
      User? found;
      for (final u in all) {
        if (u.name.toLowerCase() == key.toLowerCase()) {
          found = u;
          break;
        }
      }
      user = found;
    }

    if (user == null) {
      return const AuthResult.failure(
        'Користувача не знайдено',
      );
    }

    if (user.password != password) {
      return const AuthResult.failure(
        'Невірний пароль',
      );
    }

    await repository.setCurrentUserEmail(user.email);
    return AuthResult.success(user);
  }

  Future<void> logout() async {
    await repository.clearCurrentUser();
  }
}
