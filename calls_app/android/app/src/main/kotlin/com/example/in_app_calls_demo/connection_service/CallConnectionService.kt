package com.example.in_app_calls_demo.connection_service

import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.telecom.*
import android.util.Log
import androidx.annotation.RequiresApi
import com.example.in_app_calls_demo.models.CallData
import com.example.in_app_calls_demo.utils.Constants
import java.lang.Exception

@RequiresApi(Build.VERSION_CODES.M)
class CallConnectionService : ConnectionService() {
    companion object {
        private const val tag = "CallConnectionService"
    }

    override fun onCreateOutgoingConnection(connectionManagerPhoneAccount: PhoneAccountHandle?, request: ConnectionRequest?): Connection {
        return super.onCreateOutgoingConnection(connectionManagerPhoneAccount, request)
    }

    override fun onCreateOutgoingConnectionFailed(connectionManagerPhoneAccount: PhoneAccountHandle?, request: ConnectionRequest?) {
        super.onCreateOutgoingConnectionFailed(connectionManagerPhoneAccount, request)
    }

    override fun onCreateIncomingConnection(phoneAccount: PhoneAccountHandle?, request: ConnectionRequest?): Connection {
        Log.i(tag, "onCreateIncomingConnection called. " + phoneAccount.toString() + " " + request)

        val extras: Bundle = request!!.extras
        val callData: CallData? = extras.getSerializable(Constants.CALL_DATA) as CallData?
        val phoneUri: Uri? = extras.getParcelable(TelecomManager.EXTRA_INCOMING_CALL_ADDRESS)
        val videoState: Int = extras.getInt(TelecomManager.EXTRA_START_CALL_WITH_VIDEO_STATE, 0)

        if (callData != null) {
            val connection = CallConnection(applicationContext, callData)
            connection.videoState = videoState
            connection.setAddress(phoneUri, TelecomManager.PRESENTATION_ALLOWED)
            connection.setCallerDisplayName(callData.callerName, TelecomManager.PRESENTATION_ALLOWED)
            connection.setRinging()
            return connection
        } else {
            throw Exception("$tag: CallData must be provided.")
        }
    }

    override fun onCreateIncomingConnectionFailed(connectionManagerPhoneAccount: PhoneAccountHandle?, request: ConnectionRequest?) {
        super.onCreateIncomingConnectionFailed(connectionManagerPhoneAccount, request)
    }
}