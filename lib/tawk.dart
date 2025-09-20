import 'tawk_platform_interface.dart';

export 'src/tawk_chat.dart' show TawkChat, TawkController;

/// Miscellaneous platform helpers exposed by the plugin.
///
/// This class is intentionally minimal — primary API for embedding the chat
/// is the [TawkChat] widget exported from this package.
class Tawk {
  /// Returns the platform version reported by the platform implementation.
  Future<String?> getPlatformVersion() {
    return TawkPlatform.instance.getPlatformVersion();
  }
}
