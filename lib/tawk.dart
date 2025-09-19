// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'tawk_platform_interface.dart';

export 'src/tawk_chat.dart' show TawkChat;

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
