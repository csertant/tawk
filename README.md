# tawk

[![pub package](https://img.shields.io/pub/v/tawk.svg)](https://pub.dev/packages/tawk)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![CI](https://github.com/csertant/tawk/actions/workflows/test.yaml/badge.svg)](https://github.com/csertant/tawk/actions)

A small Flutter plugin that embeds the tawk.to chat widget. Works on web (DOM injection) and on mobile/desktop using a WebView.

## Quick example

```dart
import 'package:flutter/material.dart';
import 'package:tawk/tawk.dart';

class MyChatPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Support')),
			body: const TawkChat(propertyId: 'YOUR_PROPERTY_ID_HERE'),
		);
	}
}
```

See `example/lib/main.dart` for a working example that demonstrates how to provide your tawk property id.

## Installation

Add the package to your `pubspec.yaml` (or run `flutter pub add tawk`).

On web the plugin injects the tawk.to script into the page. On other platforms it uses a WebView to host the tawk widget.

## Usage

Minimal usage as a widget:

```dart
import 'package:flutter/material.dart';
import 'package:tawk/tawk.dart';

class MyChatPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Support')),
			body: const TawkChat(propertyId: 'YOUR_PROPERTY_ID_HERE'),
		);
	}
}
```

Notes on platforms:
- Web: the plugin injects the tawk script into the DOM. The visible area in Flutter is a placeholder; the actual chat UI will be rendered by tawk in the page. If you need tight layout control consider using an HtmlElementView-based approach in the example (coming soon).
- Mobile/Desktop: uses a WebView to load the tawk script in an isolated HTML page. JavaScript is enabled.

Privacy / Legal:
This package includes an integration with the third-party tawk.to service. You must provide your own property id and ensure you comply with tawk.to's terms and applicable privacy laws (GDPR, CCPA, etc.).
