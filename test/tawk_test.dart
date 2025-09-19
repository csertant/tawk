import 'package:flutter_test/flutter_test.dart';
import 'package:tawk/tawk.dart';
import 'package:tawk/tawk_platform_interface.dart';
import 'package:tawk/tawk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTawkPlatform
    with MockPlatformInterfaceMixin
    implements TawkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TawkPlatform initialPlatform = TawkPlatform.instance;

  test('$MethodChannelTawk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTawk>());
  });

  test('getPlatformVersion', () async {
    Tawk tawkPlugin = Tawk();
    MockTawkPlatform fakePlatform = MockTawkPlatform();
    TawkPlatform.instance = fakePlatform;

    expect(await tawkPlugin.getPlatformVersion(), '42');
  });
}
