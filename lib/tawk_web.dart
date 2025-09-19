// Minimal web entry file for the tawk plugin.
// This file is referenced by pubspec.yaml (fileName) and can be used to
// register a web implementation if needed. For now it simply re-exports
// the web widget.

export 'src/tawk_chat_web.dart' show TawkChatWeb;

// Provide a minimal registerWith to satisfy the generated web plugin
// registrant which will call `TawkWeb.registerWith(registrar)`.
// Import is deferred here to avoid adding a hard dependency on
// flutter_web_plugins when not compiling for web.
// The signature must match: static void registerWith(Registrar registrar)
// but we keep the body empty because the widget is used directly by apps.
class TawkWeb {
  const TawkWeb();

  static void registerWith(Object registrar) {
    // No-op registration hook. Provided to satisfy generated registrant.
    // If in the future the plugin needs platform-level registration on web,
    // implement it here using the flutter_web_plugins Registrar API.
  }
}
