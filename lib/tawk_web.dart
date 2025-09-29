// Web entry point for Tawk.to plugin.

export 'src/tawk_chat_web.dart' show TawkChatWeb;

/// Web plugin registration.
class TawkWeb {
  const TawkWeb();

  /// Plugin registration hook (no-op).
  /// registration is later required.
  static void registerWith(Object registrar) {
    // No-op registration hook. Provided to satisfy generated registrant.
    // If in the future the plugin needs platform-level registration on web,
    // implement it here using the flutter_web_plugins Registrar API.
  }
}
