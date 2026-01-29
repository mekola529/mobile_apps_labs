import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/local_user_repository.dart';
import 'package:flutter_application_1/screens/debug_users_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username; // this is user's email

  const HomeScreen({required this.username, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = const LocalUserRepository();
  String _displayName = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _repo.getUser(widget.username);
    if (!mounted) return;
    setState(() {
      _displayName = user?.name ?? widget.username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головна'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).pushNamed(
              '/profile',
              arguments: widget.username,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const DebugUsersScreen(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ласкаво просимо, $_displayName!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Головна сторінка',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Тут буде основна програма...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
