import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tawk/tawk.dart';

void main() {
  group('TawkController', () {
    test('should create controller with chatUrl', () {
      const testUrl = 'https://tawk.to/chat/test/test';
      final controller = TawkController(chatUrl: testUrl);
      expect(controller.chatUrl, testUrl);
    });

    test('should report closed state initially', () async {
      final controller = TawkController(
        chatUrl: 'https://tawk.to/chat/test/test',
      );
      expect(await controller.isOpen(), false);
    });
  });

  group('TawkChat Widget', () {
    testWidgets('should create with chatUrl', (WidgetTester tester) async {
      const testUrl = 'https://tawk.to/chat/test/test';

      await tester.pumpWidget(
        const MaterialApp(
          home: TawkChat(chatUrl: testUrl, child: Text('Test')),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should create with controller', (WidgetTester tester) async {
      final controller = TawkController(
        chatUrl: 'https://tawk.to/chat/test/test',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: TawkChat(controller: controller, child: const Text('Test')),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });
  });
}
