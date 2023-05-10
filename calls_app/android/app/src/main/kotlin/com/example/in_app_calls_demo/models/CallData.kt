package com.example.in_app_calls_demo.models

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
class CallData(
        val channelId: String?,
        val callerId: String?,
        val callerPhone: String?,
        val callerName: String?,
        val hasVideo: Boolean?,
) : Parcelable {
    fun hasVideoToInt(): Int {
        if (hasVideo == true) return 1
        return 0
    }

    fun toMap(): HashMap<String, Any?> {
        return hashMapOf(
                "channelId" to channelId,
                "callerId" to callerId,
                "callerPhone" to callerPhone,
                "callerName" to callerName,
                "hasVideo" to hasVideo
        )
    }
}