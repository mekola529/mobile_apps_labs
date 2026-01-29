import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/local_user_repository.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _auth = const AuthService(repository: LocalUserRepository());
  String _error = '';

  void _register() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    setState(() => _error = '');
    final res = await _auth.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirm,
    );

    if (res.success) {
      // auto-login after successful registration
      await const LocalUserRepository().setCurrentUserEmail(email.trim());
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home', arguments: email.trim());
    } else {
      setState(() => _error = res.message ?? 'Помилка');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Логін',
                  hint: '',
                  controller: _nameController,
                  icon: Icons.person,
                ),
                CustomTextField(
                  label: 'Email',
                  hint: 'example@email.com',
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
                CustomTextField(
                  label: 'Підтвердіть пароль',
                  hint: '',
                  isPassword: true,
                  controller: _confirmPasswordController,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 32),
                if (_error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      _error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                CustomButton(
                  label: 'Зареєструватися',
                  onPressed: _register,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Вже маєте обліковий запис? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/login'),
                      child: const Text('Вхід'),
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
