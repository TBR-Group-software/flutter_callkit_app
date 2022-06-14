package com.example.in_app_calls_demo.connection_service

import android.content.Context
import android.os.Build
import android.telecom.Connection
import android.telecom.DisconnectCause
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.lifecycle.Lifecycle
import com.example.in_app_calls_demo.CallsApplication
import com.example.in_app_calls_demo.models.CallData

@RequiresApi(Build.VERSION_CODES.M)
class CallConnection(private val context: Context, private val callData: CallData) : Connection() {
    companion object {
        private const val tag = "CallConnection"
    }

    override fun onShowIncomingCallUi() {
        Log.d(tag, "onShowIncomingCallUi called")
        super.onShowIncomingCallUi()
    }

    override fun onDisconnect() {
        Log.d(tag, "onDisconnect called")
        super.onDisconnect()
        setDisconnected(DisconnectCause(DisconnectCause.LOCAL))
        destroy()
    }

    override fun onAbort() {
        Log.d(tag, "onAbort called")
        super.onAbort()
        setDisconnected(DisconnectCause(DisconnectCause.CANCELED))
        destroy()
    }

    override fun onAnswer() {
        Log.d(tag, "onAnswer called")
        super.onAnswer()

        val application = context.applicationContext as CallsApplication
        val applicationState = application.getApplicationState()
        if (applicationState == Lifecycle.Event.ON_START) {
            application.sendForegroundAnsweredCallData(callData)
        } else if (applicationState == Lifecycle.Event.ON_STOP) {
            application.backToForeground()
            application.sendForegroundAnsweredCallData(callData)
        } else if (applicationState == Lifecycle.Event.ON_DESTROY || applicationState == null) {
            application.startMainActivityWithCallData(callData)
        }

        onDisconnect()
    }

    override fun onReject() {
        Log.d(tag, "onReject called")
        super.onReject()
        setDisconnected(DisconnectCause(DisconnectCause.REJECTED))
        destroy()
    }
}