import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tawk_platform_interface.dart';

/// An implementation of [TawkPlatform] that uses method channels.
class MethodChannelTawk extends TawkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tawk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
