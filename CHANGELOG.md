## 0.1.0 - Initial release (unreleased)

### Added

- **TawkChat widget** with flexible integration options
  - Controller-based API with `TawkController` for programmatic control
  - Direct URL usage for simple integrations
  - `TawkController.of(context)` for accessing controller anywhere in widget tree

- **Cross-platform support**
  - **Web**: Efficient DOM script injection using `dart:js_interop`
  - **Mobile/Desktop**: Full-screen WebView integration with `webview_flutter`
  - Automatic platform detection and appropriate rendering

- **Developer experience**
  - Comprehensive example app with best practices
  - Complete test suite covering URL parsing and widget functionality
  - Modern Dart features (record types, null safety)

- **Security & Privacy**
  - Minimal permission model
  - Secure iframe attributes
  - OnBackInvokedCallback support for Android 13+
