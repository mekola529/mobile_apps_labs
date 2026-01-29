import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/register_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init Hive and open boxes
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('users_box');
  await Hive.openBox<dynamic>('meta_box');

  // migrate from SharedPreferences if data exists
  final prefs = await SharedPreferences.getInstance();
  final usersRaw = prefs.getString('users_map');
  if (usersRaw != null) {
    try {
      final decoded = jsonDecode(usersRaw) as Map<String, dynamic>;
      final Box<dynamic> usersBox = Hive.box<dynamic>('users_box');
      for (final entry in decoded.entries) {
        usersBox.put(entry.key, entry.value);
      }
      await prefs.remove('users_map');
    } catch (_) {
      // ignore malformed data
    }
  }

  final current = prefs.getString('current_user_email');
  if (current != null) {
    final Box<dynamic> meta = Hive.box<dynamic>('meta_box');
    meta.put('current_user_email', current);
    await prefs.remove('current_user_email');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Application 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ),
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) => HomeScreen(
                username: settings.arguments as String,
              ),
            );
          case '/profile':
            return MaterialPageRoute(
              builder: (context) => ProfileScreen(
                username: settings.arguments as String,
              ),
            );
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            );
          case '/login':
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          default:
            return null;
        }
      },
    );
  }
}
