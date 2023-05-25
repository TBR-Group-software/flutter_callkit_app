package com.tbrgroup.in_app_calls_demo.connection_service

import android.net.Uri
import android.telecom.*
import android.util.Log
import com.tbrgroup.in_app_calls_demo.models.CallData
import com.tbrgroup.in_app_calls_demo.utils.Constants

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

        val extras = request!!.extras

        val incomingExtras = extras.getBundle(TelecomManager.EXTRA_INCOMING_CALL_EXTRAS)
        incomingExtras?.classLoader = CallData::class.java.classLoader
        val callData: CallData? = incomingExtras?.getParcelable(Constants.CALL_DATA)

        val phoneUri: Uri? = extras.getParcelable(TelecomManager.EXTRA_INCOMING_CALL_ADDRESS)
        val videoState = extras.getInt(TelecomManager.EXTRA_START_CALL_WITH_VIDEO_STATE, 0)

        val connection = CallConnection(applicationContext, callData!!)
        connection.videoState = videoState
        connection.setAddress(phoneUri, TelecomManager.PRESENTATION_ALLOWED)
        connection.setCallerDisplayName(callData.callerName
                ?: "Unknown", TelecomManager.PRESENTATION_ALLOWED)
        connection.setRinging()
        return connection
    }

    override fun onCreateIncomingConnectionFailed(connectionManagerPhoneAccount: PhoneAccountHandle?, request: ConnectionRequest?) {
        super.onCreateIncomingConnectionFailed(connectionManagerPhoneAccount, request)
    }
}