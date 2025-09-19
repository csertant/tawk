// Minimal web entry file for the tawk plugin.
// This file is referenced by pubspec.yaml (fileName) and can be used to
// register a web implementation if needed. For now it simply re-exports
// the web widget.

export 'src/tawk_chat_web.dart' show TawkChatWeb;

/// Dummy class referenced as pluginClass in pubspec.yaml. If you later
/// want to perform plugin registration for web, implement registration here.
class TawkWeb {
  const TawkWeb();
}
