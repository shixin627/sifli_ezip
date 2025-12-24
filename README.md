# sifli_ezip

A Flutter plugin that transforms PNG data to EZIP binary format and supports GIF to APNG conversion, compatible with Sifli hardware boards (55x, 56x, 52x series).

## Features

- Convert PNG images to EZIP binary format
- Support for GIF to APNG conversion
- Multiple color type support: RGB565, RGB565A, RGB888, RGB888A
- Alpha channel control
- Rotation support configuration
- Multiple hardware board type support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  sifli_ezip: ^0.0.1
```

### Android Setup

Add the following Maven repositories to your app's `android/build.gradle` or `android/build.gradle.kts`:

**For Groovy DSL (build.gradle):**
```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url 'https://maven.aliyun.com/repository/public'
        }
        maven {
            credentials {
                username '65a890ad4f41789f56425965'
                password 'Y-kxYEyTl5)['
            }
            url 'https://packages.aliyun.com/maven/repository/2457536-release-P0YgD8/'
        }
    }
}
```

**For Kotlin DSL (build.gradle.kts):**
```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.aliyun.com/repository/public")
        }
        maven {
            credentials {
                username = "65a890ad4f41789f56425965"
                password = "Y-kxYEyTl5)["
            }
            url = uri("https://packages.aliyun.com/maven/repository/2457536-release-P0YgD8/")
        }
    }
}
```

The plugin automatically includes the Sifli EZIP SDK dependency (`com.sifli:sifliezipsdk:2.4.3`).

### iOS Setup

**Important:** You need to manually add the Sifli eZIPSDK framework to your iOS project.

1. Download the `eZIPSDK.framework` from Sifli's official source
2. Place the framework file in: `ios/Frameworks/eZIPSDK.framework`
3. Run `pod install` in the `ios` directory

Your `ios/Frameworks/` directory structure should look like:
```
ios/
├── Frameworks/
│   └── eZIPSDK.framework/
│       ├── eZIPSDK
│       ├── Info.plist
│       └── Headers/
```

## Usage

```dart
import 'package:sifli_ezip/sifli_ezip.dart';
import 'dart:typed_data';
import 'dart:io';

final sifliEzip = SifliEzip();

// Read PNG file
Uint8List pngData = await File('path/to/image.png').readAsBytes();

// Convert to EZIP
Uint8List? ezipData = await sifliEzip.pngToEzip(
  pngData: pngData,
  colorType: 'rgb565A',      // Color type: rgb565, rgb565A, rgb888, rgb888A
  ezipColorType: 0,          // 0: preserve alpha channel, 1: no alpha channel
  ezipBinType: 1,            // 0: support rotation, 1: no rotation support
  boardType: 1,              // Board type: 0 for 55x, 1 for 56x, 2 for 52x
);

if (ezipData != null) {
  // Successfully converted
  await File('output.ezip').writeAsBytes(ezipData);
  print('Conversion successful!');
} else {
  // Conversion failed
  print('Failed to convert PNG to EZIP');
}
```

## API Reference

### `pngToEzip`

Converts PNG data to EZIP binary format.

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `pngData` | `Uint8List` | PNG or GIF image data as bytes |
| `colorType` | `String` | Color type: "rgb565", "rgb565A", "rgb888", "rgb888A" |
| `ezipColorType` | `int` | 0 to preserve original alpha channel; 1 for no alpha channel |
| `ezipBinType` | `int` | 0 to support rotation; 1 for no rotation support |
| `boardType` | `int` | Hardware board type: 0 for 55x, 1 for 56x, 2 for 52x |

**Returns:**

`Future<Uint8List?>` - The converted EZIP binary data, or `null` if conversion fails.

## Color Type Guide

- **rgb565**: 16-bit color without alpha channel (Red: 5 bits, Green: 6 bits, Blue: 5 bits)
- **rgb565A**: 16-bit color with alpha channel
- **rgb888**: 24-bit true color without alpha channel (8 bits per channel)
- **rgb888A**: 32-bit true color with alpha channel (8 bits per channel + alpha)

## Board Type Reference

- **0**: Sifli 55x series
- **1**: Sifli 56x series
- **2**: Sifli 52x series

## License

Please refer to the LICENSE file in this repository.

## Support

For more information about Sifli EZIP SDK, visit the [official documentation](https://docs.sifli.com/projects/solution/mobile-sdk/ezip/).

