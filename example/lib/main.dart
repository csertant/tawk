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
  // Replace this with your real tawk chat URL when testing, e.g.
  // https://tawk.to/chat/<property>/<widgetId>
  static const _exampleChatUrl =
      'https://tawk.to/chat/68cd0026a6f19a1922e79939/1j5gch5k0';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tawk Chat')),
      body: TawkChat(chatUrl: _exampleChatUrl),
    );
  }
}
