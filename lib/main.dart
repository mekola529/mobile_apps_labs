import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Лаб 1 Інтерактивний лічильник',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;
  final controller = TextEditingController();
  String message = '';

  void updateCounter() {
    final input = controller.text.trim().toLowerCase();
    final value = int.tryParse(input);

    setState(() {
      if (input == 'avada kedavra' || input == 'авада кедавра') {
        counter = 0;
        message = '🪄 Лічильник скинуто!';
      } else if (value != null) {
        counter += value;

        if (value < 0) {
          message = '➖ Віднято ${value.abs()}';
        } else {
          message = '➕ Додано $value';
        }
      } else {
        message = '❗ Введіть число або "Avada Kedavra"';
      }
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лаб 1 Інтерактивний лічильник')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => updateCounter(),
              decoration: const InputDecoration(
                labelText: 'Число або чарівне слово',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: updateCounter,
              child: const Text('Підтвердити'),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.indigoAccent),
            ),
          ],
        ),
      ),
    );
  }
}
