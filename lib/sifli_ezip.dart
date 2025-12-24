import 'dart:typed_data';

import 'sifli_ezip_platform_interface.dart';

class SifliEzip {
  Future<String?> getPlatformVersion() {
    return SifliEzipPlatform.instance.getPlatformVersion();
  }

  /// Converts PNG data to EZIP binary format.
  ///
  /// Parameters:
  /// - [pngData]: PNG or GIF image data as bytes
  /// - [colorType]: Color type - "rgb565", "rgb565A", "rgb888", "rgb888A"
  /// - [ezipColorType]: 0 to preserve original alpha channel; 1 for no alpha channel
  /// - [ezipBinType]: 0 to support rotation; 1 for no rotation support
  /// - [boardType]: Hardware board type - 0 for 55x, 1 for 56x, 2 for 52x
  ///
  /// Returns the converted EZIP binary data, or null if conversion fails.
  Future<Uint8List?> pngToEzip({
    required Uint8List pngData,
    required String colorType,
    required int ezipColorType,
    required int ezipBinType,
    required int boardType,
  }) {
    return SifliEzipPlatform.instance.pngToEzip(
      pngData: pngData,
      colorType: colorType,
      ezipColorType: ezipColorType,
      ezipBinType: ezipBinType,
      boardType: boardType,
    );
  }
}
