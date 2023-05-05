package com.example.in_app_calls_demo.connection_service

import android.content.Context
import android.telecom.Connection
import android.telecom.DisconnectCause
import android.util.Log
import androidx.lifecycle.Lifecycle
import com.example.in_app_calls_demo.CallsApplication
import com.example.in_app_calls_demo.models.CallData

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
        when (application.getApplicationState()) {
            Lifecycle.Event.ON_START -> {
                application.sendForegroundAnsweredCallData(callData)
            }
            Lifecycle.Event.ON_STOP -> {
                application.backToForeground()
                application.sendForegroundAnsweredCallData(callData)
            }
            Lifecycle.Event.ON_DESTROY, null -> {
                application.startMainActivityWithCallData(callData)
            }
            else -> {}
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