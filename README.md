# tawk

[![pub package](https://img.shields.io/pub/v/tawk.svg)](https://pub.dev/packages/tawk)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![CI](https://github.com/csertant/tawk/actions/workflows/test.yaml/badge.svg)](https://github.com/csertant/tawk/actions)

A small Flutter plugin that embeds the tawk.to chat widget. Works on web (DOM injection) and on mobile/desktop using a WebView.

## Quick example

```dart
import 'package:flutter/material.dart';
import 'package:tawk/tawk.dart';
// Create a single controller and place TawkChat near the app root so the
// embed script is installed on web and the controller is available across
// the app on mobile.
void main() {
	final tawkController = TawkController(chatUrl: 'https://tawk.to/chat/<id>/<widget>');
	runApp(MyApp(tawkController: tawkController));
}

class MyApp extends StatelessWidget {
	final TawkController tawkController;
	const MyApp({required this.tawkController, super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			home: Stack(
				children: [
					HomeScreen(),
					// Place the TawkChat near the app root. On web this installs the
					// tawk script (floating widget). On mobile the controller is
					// registered and can open a full-screen WebView when requested.
					// You can pass only the controller (the widget will use
					// controller.chatUrl), avoiding duplicate chatUrl parameters.
					TawkChat(controller: tawkController),
				],
			),
		);
	}
}

class HomeScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		// Obtain the controller and open the chat when needed.
		final controller = TawkController.of(context);

		return Scaffold(
			appBar: AppBar(title: const Text('Support')),
			body: Center(
				child: ElevatedButton(
					onPressed: () => controller.open(context),
					child: const Text('Open chat'),
				),
			),
		);
	}
}
```

See `example/lib/main.dart` for a working example that demonstrates how to provide your tawk chat URL.

## Installation

Add the package to your `pubspec.yaml` (or run `flutter pub add tawk`).

On web and mobile the plugin opens the tawk chat URL in an iframe/webview. Provide a full chat URL (e.g. https://tawk.to/chat/<id>/<widget>).

## Usage

Recommended pattern (single controller + root placement)

1) Create a single `TawkController` (for example in `main()`).
2) Place `TawkChat` near the app root so it installs the script on web and
	 exposes the controller to the app via `TawkController.of(context)`.
3) Open the chat programmatically with `controller.open(context)` where you
	 need it (e.g., a FAB or menu action).

Minimal imperative usage example

```dart
final controller = TawkController(chatUrl: 'https://tawk.to/chat/<id>/<widget>');

// place the widget near the root (only controller required):
TawkChat(controller: controller);

// open from anywhere in the subtree:
TawkController.of(context).open(context);
```

Platform behavior
- Web: the plugin injects the official `tawk.to` embed script into the
	page (once). That script renders the floating chat widget (bottom-right)
	in the host page. The `TawkChat` widget on web is primarily responsible for
	installing the script and exposing the controller.
- Mobile/Desktop: the plugin opens a full-screen page with a WebView that
	loads the same embed HTML (so behavior is consistent); this keeps the
	chat experience platform-conformant on mobile.

Privacy / Legal:
This package includes an integration with the third-party tawk.to service. You must provide your own chat URL and ensure you comply with tawk.to's terms and applicable privacy laws (GDPR, CCPA, etc.).
