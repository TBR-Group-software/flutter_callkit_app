package com.example.in_app_calls_demo.call_kit

import android.content.Context
import android.util.Log
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
        private const val hasPhoneAccountMethod = "hasPhoneAccount"
        private const val createPhoneAccountMethod = "createPhoneAccount"
        private const val openPhoneAccountsMethod = "openPhoneAccounts"
    }

    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            hasPhoneAccountMethod -> {
                hasPhoneAccount(result)
            }
            createPhoneAccountMethod -> {
                createPhoneAccount(result)
            }
            openPhoneAccountsMethod -> {
                openPhoneAccounts(result)
            }
            else -> result.notImplemented()
        }
    }

    private fun hasPhoneAccount(result: MethodChannel.Result) {
        Log.i(tag, "$hasPhoneAccountMethod is called")

        val telecomManager = TelecomManagerHelper(context)
        val phoneAccount = telecomManager.getPhoneAccount()
        val enabled = phoneAccount != null && phoneAccount.isEnabled
        result.success(enabled)
    }

    private fun createPhoneAccount(result: MethodChannel.Result) {
        Log.i(tag, "$createPhoneAccountMethod is called")

        val telecomManager = TelecomManagerHelper(context)
        val phoneAccount = telecomManager.createPhoneAccount()
        result.success(phoneAccount.isEnabled)
    }

    private fun openPhoneAccounts(result: MethodChannel.Result) {
        Log.i(tag, "$openPhoneAccountsMethod is called")

        val callsApp = context.applicationContext as CallsApplication
        result.success(callsApp.openPhoneAccounts())
    }
}