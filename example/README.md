# tawk_example

Demonstrates how to use the `tawk` plugin and the `TawkChat` widget.

## Usage

1. Open `example/lib/main.dart` and replace `YOUR_PROPERTY_ID_HERE` with your actual tawk.to property id.
2. Run the example for your target platform:

Flutter web:

```bash
flutter run -d chrome
```

Android/iOS:

```bash
flutter run
```

Notes

- On web this example injects the tawk.to script into the host page. For inline rendering and better layout control, consider implementing an HtmlElementView-backed embed.
- On mobile platforms the plugin uses a WebView to host the tawk.to embed.
