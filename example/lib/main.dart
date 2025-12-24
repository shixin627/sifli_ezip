import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sifli_ezip/sifli_ezip.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _sifliEzipPlugin = SifliEzip();

  // Conversion parameters
  String? _selectedFilePath;
  String _colorType = 'rgb565A';
  int _ezipColorType = 0;
  int _ezipBinType = 1;
  int _boardType = 1;

  // Results
  String _statusMessage = 'Select a PNG file to convert';
  bool _isConverting = false;
  int? _originalSize;
  int? _convertedSize;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _sifliEzipPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'PNG'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path;
          _statusMessage = 'File selected: ${result.files.single.name}';
          _originalSize = null;
          _convertedSize = null;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error selecting file: $e';
      });
    }
  }

  Future<void> _convertToEzip() async {
    if (_selectedFilePath == null) {
      setState(() {
        _statusMessage = 'Please select a PNG file first';
      });
      return;
    }

    setState(() {
      _isConverting = true;
      _statusMessage = 'Converting...';
    });

    try {
      // Read PNG file
      final File pngFile = File(_selectedFilePath!);
      final Uint8List pngData = await pngFile.readAsBytes();
      _originalSize = pngData.length;

      // Convert to EZIP
      final Uint8List? ezipData = await _sifliEzipPlugin.pngToEzip(
        pngData: pngData,
        colorType: _colorType,
        ezipColorType: _ezipColorType,
        ezipBinType: _ezipBinType,
        boardType: _boardType,
      );

      if (ezipData != null) {
        _convertedSize = ezipData.length;

        // Save the EZIP file
        final Directory directory = await getApplicationDocumentsDirectory();
        final String fileName =
            '${pngFile.path.split('/').last.replaceAll('.png', '')}_converted.ezip';
        final String outputPath = '${directory.path}/$fileName';
        final File outputFile = File(outputPath);
        await outputFile.writeAsBytes(ezipData);

        setState(() {
          _statusMessage = 'Conversion successful!\n'
              'Original size: ${(_originalSize! / 1024).toStringAsFixed(2)} KB\n'
              'Converted size: ${(_convertedSize! / 1024).toStringAsFixed(2)} KB\n'
              'Saved to: $outputPath';
          _isConverting = false;
        });
      } else {
        setState(() {
          _statusMessage = 'Conversion failed: SDK returned null';
          _isConverting = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error during conversion: $e';
        _isConverting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sifli EZIP Test App'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Platform info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Platform: $_platformVersion',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // File selection
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.folder_open),
                label: const Text('Select PNG File'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),

              // Conversion parameters
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conversion Parameters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Color Type
                      Row(
                        children: [
                          const Expanded(child: Text('Color Type:')),
                          DropdownButton<String>(
                            value: _colorType,
                            items: const [
                              DropdownMenuItem(value: 'rgb565', child: Text('RGB565')),
                              DropdownMenuItem(value: 'rgb565A', child: Text('RGB565A')),
                              DropdownMenuItem(value: 'rgb888', child: Text('RGB888')),
                              DropdownMenuItem(value: 'rgb888A', child: Text('RGB888A')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _colorType = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      // EZIP Color Type
                      Row(
                        children: [
                          const Expanded(child: Text('Alpha Channel:')),
                          DropdownButton<int>(
                            value: _ezipColorType,
                            items: const [
                              DropdownMenuItem(value: 0, child: Text('Preserve')),
                              DropdownMenuItem(value: 1, child: Text('Remove')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _ezipColorType = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      // EZIP Bin Type
                      Row(
                        children: [
                          const Expanded(child: Text('Rotation Support:')),
                          DropdownButton<int>(
                            value: _ezipBinType,
                            items: const [
                              DropdownMenuItem(value: 0, child: Text('Enabled')),
                              DropdownMenuItem(value: 1, child: Text('Disabled')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _ezipBinType = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      // Board Type
                      Row(
                        children: [
                          const Expanded(child: Text('Board Type:')),
                          DropdownButton<int>(
                            value: _boardType,
                            items: const [
                              DropdownMenuItem(value: 0, child: Text('55x')),
                              DropdownMenuItem(value: 1, child: Text('56x')),
                              DropdownMenuItem(value: 2, child: Text('52x')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _boardType = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Convert button
              ElevatedButton.icon(
                onPressed: _isConverting ? null : _convertToEzip,
                icon: _isConverting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.transform),
                label: Text(_isConverting ? 'Converting...' : 'Convert to EZIP'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Status message
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _statusMessage,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
