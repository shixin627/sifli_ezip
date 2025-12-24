import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sifli_ezip_method_channel.dart';

abstract class SifliEzipPlatform extends PlatformInterface {
  /// Constructs a SifliEzipPlatform.
  SifliEzipPlatform() : super(token: _token);

  static final Object _token = Object();

  static SifliEzipPlatform _instance = MethodChannelSifliEzip();

  /// The default instance of [SifliEzipPlatform] to use.
  ///
  /// Defaults to [MethodChannelSifliEzip].
  static SifliEzipPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SifliEzipPlatform] when
  /// they register themselves.
  static set instance(SifliEzipPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Uint8List?> pngToEzip({
    required Uint8List pngData,
    required String colorType,
    required int ezipColorType,
    required int ezipBinType,
    required int boardType,
  }) {
    throw UnimplementedError('pngToEzip() has not been implemented.');
  }
}
