package com.skaiwalk.sifli_ezip

import com.sifli.ezip.sifliEzipUtil
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SifliEzipPlugin */
class SifliEzipPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sifli_ezip")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "pngToEzip" -> {
                try {
                    val pngData = call.argument<ByteArray>("pngData")
                    val colorType = call.argument<String>("colorType")
                    val ezipColorType = call.argument<Int>("ezipColorType")
                    val ezipBinType = call.argument<Int>("ezipBinType")
                    val boardType = call.argument<Int>("boardType")

                    if (pngData == null || colorType == null || ezipColorType == null ||
                        ezipBinType == null || boardType == null) {
                        result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                        return
                    }

                    val ezipData = sifliEzipUtil.pngToEzip(
                        pngData,
                        colorType,
                        ezipColorType,
                        ezipBinType,
                        boardType
                    )

                    if (ezipData != null) {
                        result.success(ezipData)
                    } else {
                        result.error("CONVERSION_FAILED", "Failed to convert PNG to EZIP", null)
                    }
                } catch (e: Exception) {
                    result.error("EXCEPTION", e.message, null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
