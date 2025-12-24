# iOS Frameworks Directory

This directory is for the Sifli eZIPSDK framework.

## Setup Instructions

1. **Download the eZIPSDK.framework** from Sifli's official source or contact Sifli support to obtain the framework.

2. **Place the framework here:**
   ```
   ios/Frameworks/eZIPSDK.framework/
   ```

3. **Verify the framework structure:**
   ```
   eZIPSDK.framework/
   ├── eZIPSDK           (Binary file)
   ├── Info.plist
   └── Headers/
       └── eZIPSDK.h     (or other header files)
   ```

4. **Run pod install:**
   ```bash
   cd ios
   pod install
   ```

## Expected Directory Structure

```
ios/
├── Frameworks/
│   └── eZIPSDK.framework/
│       ├── eZIPSDK
│       ├── Info.plist
│       └── Headers/
├── Classes/
├── sifli_ezip.podspec
└── ...
```

## Troubleshooting

If you encounter build errors:

1. **Clean the build:**
   ```bash
   cd ios
   rm -rf Pods/ Podfile.lock
   pod install
   ```

2. **Check framework path:**
   Ensure the framework is in the correct location: `ios/Frameworks/eZIPSDK.framework`

3. **Verify Xcode settings:**
   - Open your project in Xcode
   - Check "Framework Search Paths" includes `$(PROJECT_DIR)/Frameworks`
   - Verify the framework is listed under "Frameworks, Libraries, and Embedded Content"

## Contact

For framework access or support, visit: https://docs.sifli.com/projects/solution/mobile-sdk/ezip/
