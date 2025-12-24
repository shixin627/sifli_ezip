import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sifli_ezip_platform_interface.dart';

/// An implementation of [SifliEzipPlatform] that uses method channels.
class MethodChannelSifliEzip extends SifliEzipPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sifli_ezip');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Uint8List?> pngToEzip({
    required Uint8List pngData,
    required String colorType,
    required int ezipColorType,
    required int ezipBinType,
    required int boardType,
  }) async {
    final result = await methodChannel.invokeMethod<Uint8List>('pngToEzip', {
      'pngData': pngData,
      'colorType': colorType,
      'ezipColorType': ezipColorType,
      'ezipBinType': ezipBinType,
      'boardType': boardType,
    });
    return result;
  }
}
