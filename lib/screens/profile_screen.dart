import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  final String username;

  const ProfileScreen({required this.username, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.indigo.withValues(alpha: 0.3),
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  username,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Користувач системи',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                CustomCard(
                  child: Column(
                    children: [
                      _buildProfileItem(
                        context,
                        icon: Icons.email,
                        label: 'Email',
                        value: '$username@example.com',
                      ),
                      const Divider(height: 24),
                      _buildProfileItem(
                        context,
                        icon: Icons.phone,
                        label: 'Телефон',
                        value: '+38 (000) 123-45-67',
                      ),
                      const Divider(height: 24),
                      _buildProfileItem(
                        context,
                        icon: Icons.location_on,
                        label: 'Місто',
                        value: 'Київ',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: 'Вийти',
                  bgColor: Colors.red.shade700,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
