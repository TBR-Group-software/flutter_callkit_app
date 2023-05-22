package com.tbrgroup.in_app_calls_demo.call_kit

import android.content.Context
import android.util.Log
import com.tbrgroup.in_app_calls_demo.CallsApplication
import com.tbrgroup.in_app_calls_demo.connection_service.TelecomManagerHelper
import com.tbrgroup.in_app_calls_demo.models.CallData
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FlutterCallKit(private val context: Context, private val backgroundCallData: CallData?, flutterEngine: FlutterEngine) {
    private var callForegroundMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, callForegroundChannel)
    private var callBackgroundMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, callBackgroundChannel)
    private var callKitMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, flutterCallKitMethodsChannel)

    init {
        callBackgroundMethodChannel.setMethodCallHandler { call, result -> handleCallBackgroundMethodCall(call, result) }
        callKitMethodChannel.setMethodCallHandler { call, result -> handleCallKitMethodCall(call, result) }
    }

    companion object {
        private const val tag = "FlutterCallKit"

        private const val callForegroundChannel = "in_app_calls_demo/call/foreground"
        private const val callAnsweredMethod = "callAnswered"

        private const val callBackgroundChannel = "in_app_calls_demo/call/background"
        private const val isAppLaunchedWithCallDataMethod = "isAppLaunchedWithCallData"

        private const val flutterCallKitMethodsChannel = "in_app_calls_demo/flutter_call_kit/methods"
        private const val hasPhoneAccountMethod = "hasPhoneAccount"
        private const val createPhoneAccountMethod = "createPhoneAccount"
        private const val openPhoneAccountsMethod = "openPhoneAccounts"
    }

    fun sendForegroundAnsweredCallData(callData: CallData) {
        Log.i(tag, "sendForegroundAnsweredCallData is called")
        callForegroundMethodChannel.invokeMethod(callAnsweredMethod, callData.toMap())
    }

    private fun handleCallBackgroundMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            isAppLaunchedWithCallDataMethod -> {
                Log.i(tag, "$isAppLaunchedWithCallDataMethod is called")
                result.success(backgroundCallData?.toMap())
            }
            else -> result.notImplemented()
        }
    }

    private fun handleCallKitMethodCall(call: MethodCall, result: MethodChannel.Result) {
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