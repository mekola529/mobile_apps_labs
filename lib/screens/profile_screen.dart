import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/repositories/local_user_repository.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/widgets/custom_button.dart';
import 'package:flutter_application_1/widgets/custom_card.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({required this.username, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _repo = const LocalUserRepository();
  final _auth = const AuthService(repository: LocalUserRepository());

  String _email = '';
  String _name = '';
  String _phone = '';
  String _city = '';

  // originals for cancel
  late String _originalName;
  late String _originalPhone;
  late String _originalCity;

  bool _loading = true;
  bool _editing = false; 

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final username = widget.username;
    final user = await _repo.getUser(username);
    if (!mounted) return;
    if (user != null) {
      setState(() {
        _email = user.email;
        _name = user.name;
        _phone = user.phone ?? '';
        _city = user.city ?? '';

        _originalName = _name;
        _originalPhone = _phone;
        _originalCity = _city;

        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    final existing = await _repo.getUser(_email);
    final password = existing?.password ?? '';

    // ensure login uniqueness
    final all = await _repo.getAllUsers();
    for (final u in all) {
      final sameLogin = u.name.toLowerCase() == _name.trim().toLowerCase();
      final differentUser = u.email != _email;
      if (sameLogin && differentUser) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Логін уже зайнятий')),
        );
        return;
      }
    }

    final user = User(
      name: _name.trim(),
      email: _email,
      password: password,
      phone: _phone.isEmpty ? null : _phone,
      city: _city.isEmpty ? null : _city,
    );

    await _repo.updateUser(user);

    setState(() {
      _originalName = _name;
      _originalPhone = _phone;
      _originalCity = _city;
      _editing = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Збережено'),
      ),
    );
  }

  Future<void> _delete() async {
    // confirm first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Підтвердження'),
        content: const Text(
          'Ви впевнені, що хочете видалити акаунт?\n'
          'Цю дію не можна відмінити.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (_email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Неможливо видалити: email невідомий')),
      );
      return;
    }

    await _repo.deleteUser(_email);
    await _repo.clearCurrentUser();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Акаунт видалено')),
    );
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _cancel() {
    setState(() {
      _name = _originalName;
      _phone = _originalPhone;
      _city = _originalCity;
      _editing = false;
    });
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        centerTitle: true,
        actions: [
          if (!_editing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _editing = true),
            ),
          if (_editing) ...[
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _save,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _cancel,
            ),
          ],
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (_loading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.indigo.withAlpha(30),
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                CustomCard(
                  child: Column(
                    children: [
                      _buildEditableItem(
                        context,
                        icon: Icons.person,
                        label: 'Логін',
                        value: _name,
                        onChanged: (v) => setState(() => _name = v),
                      ),
                      const Divider(height: 24),
                      _buildEditableItem(
                        context,
                        icon: Icons.phone,
                        label: 'Телефон',
                        value: _phone,
                        onChanged: (v) => setState(() => _phone = v),
                      ),
                      const Divider(height: 24),
                      _buildEditableItem(
                        context,
                        icon: Icons.location_on,
                        label: 'Місто',
                        value: _city,
                        onChanged: (v) => setState(() => _city = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // delete button moved to the bottom (below)

                const SizedBox(height: 24),
                // bottom delete button
                CustomButton(
                  label: 'Видалити акаунт',
                  bgColor: Colors.red.shade700,
                  onPressed: _delete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              if (_editing)
                TextFormField(
                  initialValue: value,
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                )
              else
                Text(
                  value.isEmpty ? '-' : value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
