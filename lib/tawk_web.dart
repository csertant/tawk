// Minimal web entry file for the tawk plugin.
// This file is referenced by pubspec.yaml (fileName) and can be used to
// register a web implementation if needed. For now it simply re-exports
// the web widget.

export 'src/tawk_chat_web.dart' show TawkChatWeb;

/// Minimal web entry file for the plugin.
///
/// This provides a `registerWith` hook to satisfy the generated web
/// plugin registrant. The current implementation is a no-op because the
/// web behavior is implemented by the `TawkChatWeb` widget which apps can
/// use directly.
class TawkWeb {
  const TawkWeb();

  /// Registration hook invoked by generated plugin registrant code.
  ///
  /// The `registrar` parameter is intentionally typed as `Object` to avoid
  /// importing flutter_web_plugins in this file. Implement it if platform
  /// registration is later required.
  static void registerWith(Object registrar) {
    // No-op registration hook. Provided to satisfy generated registrant.
    // If in the future the plugin needs platform-level registration on web,
    // implement it here using the flutter_web_plugins Registrar API.
  }
}
