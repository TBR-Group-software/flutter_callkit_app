package com.tbrgroup.in_app_calls_demo.connection_service

import android.content.ComponentName
import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.telecom.PhoneAccount
import android.telecom.PhoneAccountHandle
import android.telecom.TelecomManager
import com.tbrgroup.in_app_calls_demo.models.CallData
import com.tbrgroup.in_app_calls_demo.utils.Constants
import java.util.*

class TelecomManagerHelper(private val context: Context) {
    private val telecomManager: TelecomManager = context.getSystemService(Context.TELECOM_SERVICE) as TelecomManager
    private val phoneAccountHandle: PhoneAccountHandle

    init {
        val cName = ComponentName(context, CallConnectionService::class.java)
        val appName: String = getApplicationName(context)
        phoneAccountHandle = PhoneAccountHandle(cName, appName)
    }

    private fun getApplicationName(context: Context): String {
        val applicationInfo = context.applicationInfo
        val stringId = applicationInfo.labelRes
        return if (stringId == 0) applicationInfo.nonLocalizedLabel.toString() else context.getString(stringId)
    }

    fun makeCall(callData: CallData) {
        var phoneAccount = getPhoneAccount()
        if (phoneAccount == null) {
            phoneAccount = createPhoneAccount()
        }

        val uuid = UUID.randomUUID()
        val incomingExtras = Bundle().apply {
            putString(Constants.EXTRA_CALL_UUID, uuid.toString())
            putParcelable(Constants.CALL_DATA, callData)
        }

        val phoneUri = Uri.fromParts(PhoneAccount.SCHEME_TEL, callData.callerName, null)
        val extras = Bundle().apply {
            putBundle(TelecomManager.EXTRA_INCOMING_CALL_EXTRAS, incomingExtras)
            putParcelable(TelecomManager.EXTRA_INCOMING_CALL_ADDRESS, phoneUri)
            putParcelable(TelecomManager.EXTRA_PHONE_ACCOUNT_HANDLE, phoneAccount)
            putInt(TelecomManager.EXTRA_START_CALL_WITH_VIDEO_STATE, callData.hasVideoToInt())
        }


        telecomManager.addNewIncomingCall(phoneAccountHandle, extras)
    }

    fun getPhoneAccount(): PhoneAccount? = telecomManager.getPhoneAccount(phoneAccountHandle)

    fun createPhoneAccount(): PhoneAccount {
        val phoneAccount = PhoneAccount.builder(phoneAccountHandle, getApplicationName(context))
                .setCapabilities(PhoneAccount.CAPABILITY_CALL_PROVIDER).build()
        telecomManager.registerPhoneAccount(phoneAccount)
        return phoneAccount
    }
}