import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/repositories/local_user_repository.dart';

class DebugUsersScreen extends StatefulWidget {
  const DebugUsersScreen({super.key});

  @override
  State<DebugUsersScreen> createState() => _DebugUsersScreenState();
}

class _DebugUsersScreenState extends State<DebugUsersScreen> {
  final _repo = const LocalUserRepository();
  List<User> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await _repo.getAllUsers();
    if (!mounted) return;
    setState(
      () {
        _users = list;
        _loading = false;
      },
    );
  }

  Future<void> _delete(String email) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Підтвердження'),
        content: const Text(
          'Видалити цього користувача?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Ні'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Так'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await _repo.deleteUser(email);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Користувача видалено'),
      ),
    );
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Підтвердження'),
        content: const Text(
          'Видалити всіх користувачів?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Ні'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Так'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final all = await _repo.getAllUsers();
    for (final u in all) {
      await _repo.deleteUser(u.email);
    }
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Усі користувачі видалені'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug: Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearAll,
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _users.isEmpty
                ? const Center(child: Text('Користувачі відсутні'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _users.length,
                    separatorBuilder: (context, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final u = _users[index];
                      return ListTile(
                        title: Text(u.name),
                        subtitle: Text(u.email),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _delete(u.email),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
