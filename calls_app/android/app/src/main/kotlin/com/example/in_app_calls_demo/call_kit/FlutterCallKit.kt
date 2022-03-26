package com.example.in_app_calls_demo.call_kit

import android.content.Context
import android.os.Build
import com.example.in_app_calls_demo.CallsApplication
import com.example.in_app_calls_demo.connection_service.TelecomManagerHelper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FlutterCallKit(private val context: Context, flutterEngine: FlutterEngine) {
    private var callKitMethodChannel: MethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, flutterCallKitMethodsChannel)

    init {
        callKitMethodChannel.setMethodCallHandler { call, result -> handleMethodCall(call, result) }
    }

    companion object {
        private const val tag = "FlutterCallKit"

        private const val flutterCallKitMethodsChannel = "in_app_calls_demo/flutter_call_kit/methods"
    }

    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result): Boolean {
        when (call.method) {
            "hasPhoneAccount" -> {
                hasPhoneAccount(result)
            }
            "openPhoneAccounts" -> {
                openPhoneAccounts(result)
            }
            else -> return false
        }
        return true
    }

    private fun hasPhoneAccount(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val telecomManager = TelecomManagerHelper(context)
            result.success(telecomManager.hasPhoneAccount())
            return
        }
        result.error(tag, "Minimum 23 version of Android is required", null)
    }

    private fun openPhoneAccounts(result: MethodChannel.Result) {
        val callsApp = context.applicationContext as CallsApplication
        result.success(callsApp.openPhoneAccounts())
    }
}