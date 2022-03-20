package com.example.in_app_calls_demo.connection_service

import android.content.ComponentName
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.telecom.PhoneAccount
import android.telecom.PhoneAccountHandle
import android.telecom.TelecomManager
import androidx.annotation.RequiresApi
import com.example.in_app_calls_demo.models.CallData
import com.example.in_app_calls_demo.utils.Constants
import java.util.*

@RequiresApi(Build.VERSION_CODES.M)
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
        val phoneAccount = PhoneAccount.builder(phoneAccountHandle, getApplicationName(context))
                .setCapabilities(PhoneAccount.CAPABILITY_CALL_PROVIDER).build()
        telecomManager.registerPhoneAccount(phoneAccount)

        val extras = Bundle()
        val uuid = UUID.randomUUID()
        extras.putString(Constants.EXTRA_CALL_UUID, uuid.toString())
        val phoneUri = Uri.fromParts(PhoneAccount.SCHEME_TEL, callData.callerPhone, null)

        extras.putParcelable(TelecomManager.EXTRA_INCOMING_CALL_ADDRESS, phoneUri)
        extras.putParcelable(TelecomManager.EXTRA_PHONE_ACCOUNT_HANDLE, phoneAccount)
        extras.putInt(TelecomManager.EXTRA_START_CALL_WITH_VIDEO_STATE, callData.hasVideoToInt())
        extras.putSerializable(Constants.CALL_DATA, callData)

        telecomManager.addNewIncomingCall(phoneAccountHandle, extras)
    }

    fun hasPhoneAccount(): Boolean {
        val phoneAccount = telecomManager.getPhoneAccount(phoneAccountHandle)
        return phoneAccount != null && phoneAccount.isEnabled
    }
}