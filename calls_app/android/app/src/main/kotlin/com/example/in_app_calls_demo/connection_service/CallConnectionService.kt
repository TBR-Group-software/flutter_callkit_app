package com.example.in_app_calls_demo.connection_service

import android.net.Uri
import android.os.Bundle
import android.telecom.*
import android.util.Log
import com.example.in_app_calls_demo.models.CallData

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
        //TODO: take real data from Bundle
        val callData = CallData(callerId = "12345", channelId = "1", callerPhone = "+1 123 1234 12345", callerName = "Name Name", hasVideo = true)
        //val callData: CallData? = extras.getSerializable(Constants.CALL_DATA) as CallData?
        val phoneUri: Uri? = extras.getParcelable(TelecomManager.EXTRA_INCOMING_CALL_ADDRESS)
        val videoState: Int = extras.getInt(TelecomManager.EXTRA_START_CALL_WITH_VIDEO_STATE, 0)

        val connection = CallConnection(applicationContext, callData)
        connection.videoState = videoState
        connection.setAddress(phoneUri, TelecomManager.PRESENTATION_ALLOWED)
        connection.setCallerDisplayName(callData.callerName, TelecomManager.PRESENTATION_ALLOWED)
        connection.setRinging()
        return connection

    }

    override fun onCreateIncomingConnectionFailed(connectionManagerPhoneAccount: PhoneAccountHandle?, request: ConnectionRequest?) {
        super.onCreateIncomingConnectionFailed(connectionManagerPhoneAccount, request)
    }
}