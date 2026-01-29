import 'package:flutter/material.dart';
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

  void _register() {
    Navigator.of(context).pushNamed('/login');
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
                  label: 'Повне ім\'я',
                  hint: 'Іван Петренко',
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
                  hint: '••••••••',
                  isPassword: true,
                  controller: _passwordController,
                  icon: Icons.lock,
                ),
                CustomTextField(
                  label: 'Підтвердіть пароль',
                  hint: '••••••••',
                  isPassword: true,
                  controller: _confirmPasswordController,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 32),
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
