import 'package:flutter_test/flutter_test.dart';
import 'package:sifli_ezip/sifli_ezip.dart';
import 'package:sifli_ezip/sifli_ezip_platform_interface.dart';
import 'package:sifli_ezip/sifli_ezip_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSifliEzipPlatform
    with MockPlatformInterfaceMixin
    implements SifliEzipPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SifliEzipPlatform initialPlatform = SifliEzipPlatform.instance;

  test('$MethodChannelSifliEzip is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSifliEzip>());
  });

  test('getPlatformVersion', () async {
    SifliEzip sifliEzipPlugin = SifliEzip();
    MockSifliEzipPlatform fakePlatform = MockSifliEzipPlatform();
    SifliEzipPlatform.instance = fakePlatform;

    expect(await sifliEzipPlugin.getPlatformVersion(), '42');
  });
}
