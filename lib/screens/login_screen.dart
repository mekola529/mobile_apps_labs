import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/local_user_repository.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  final _auth = const AuthService(repository: LocalUserRepository());

  void _login() async {
    final login = _emailController.text.trim();
    final password = _passwordController.text.trim();
    setState(() => _errorMessage = '');

    final res = await _auth.login(login: login, password: password);
    if (res.success) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        '/home',
        arguments: res.user?.email ?? login,
      );
    } else {
      setState(() => _errorMessage = res.message ?? 'Помилка');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Text(
                  'Вхід',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Введіть облікові дані',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  label: 'Email або логін',
                  hint: '',
                  controller: _emailController,
                  icon: Icons.email,
                ),
                CustomTextField(
                  label: 'Пароль',
                  hint: '',
                  isPassword: true,
                  controller: _passwordController,
                  icon: Icons.lock,
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Увійти',
                  onPressed: _login,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Немає облікового запису? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/register'),
                      child: const Text('Реєстрація'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
