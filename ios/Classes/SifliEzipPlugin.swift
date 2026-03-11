import Flutter
import UIKit
import eZIPSDK

public class SifliEzipPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sifli_ezip", binaryMessenger: registrar.messenger())
    let instance = SifliEzipPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "pngToEzip":
      guard let args = call.arguments as? [String: Any],
            let pngData = args["pngData"] as? FlutterStandardTypedData,
            let colorType = args["colorType"] as? String,
            let ezipColorType = args["ezipColorType"] as? Int,
            let ezipBinType = args["ezipBinType"] as? Int,
            let boardType = args["boardType"] as? Int else {
        result(FlutterError(code: "INVALID_ARGUMENTS",
                           message: "Missing required arguments",
                           details: nil))
        return
      }

      // Call Sifli eZIPSDK
      if let ezipResult = ImageConvertor.eBin(
        fromPNGData: pngData.data,
        eColor: colorType,
        eType: UInt8(ezipColorType),
        binType: UInt8(ezipBinType),
        boardType: SFBoardType(rawValue: UInt(boardType)) ?? SFBoardType(rawValue: 0)!
      ) {
        result(FlutterStandardTypedData(bytes: ezipResult))
      } else {
        result(FlutterError(code: "CONVERSION_FAILED",
                           message: "Failed to convert PNG to EZIP",
                           details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
