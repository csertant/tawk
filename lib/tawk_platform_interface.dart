import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tawk_method_channel.dart';

/// Platform interface for the tawk plugin.
///
/// Platform implementations should extend this class and set
/// `TawkPlatform.instance` during registration. The default instance is a
/// method-channel implementation provided by this package.
abstract class TawkPlatform extends PlatformInterface {
  /// Constructs a TawkPlatform.
  TawkPlatform() : super(token: _token);

  static final Object _token = Object();

  static TawkPlatform _instance = MethodChannelTawk();

  /// The default instance of [TawkPlatform] to use.
  ///
  /// Defaults to [MethodChannelTawk]. Platform implementations should set
  /// this to their own instance when registering with the platform.
  static TawkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TawkPlatform] when
  /// they register themselves.
  static set instance(TawkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns a platform-specific version string. Implementations should
  /// override this and return the appropriate value.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
