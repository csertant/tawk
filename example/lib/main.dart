import 'package:flutter/material.dart';
import 'package:tawk/tawk.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tawk Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tawk Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatPage()),
            );
          },
          child: const Text('Open Tawk Chat'),
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  // Replace this with your real tawk property id when testing.
  static const _examplePropertyId = 'YOUR_PROPERTY_ID_HERE';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tawk Chat')),
      body: TawkChat(propertyId: _examplePropertyId),
    );
  }
}
