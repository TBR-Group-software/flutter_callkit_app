package com.tbrgroup.in_app_calls_demo.models

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import org.json.JSONObject

@Parcelize
class CallData(
        val channelId: String?,
        val callerId: String?,
        val callerPhone: String?,
        val callerName: String?,
        val hasVideo: Boolean?,
) : Parcelable {

    constructor(json: JSONObject) : this(
            channelId = if (json.has("channel_id")) json["channel_id"] as String? else null,
            callerId = if (json.has("caller_id")) json["caller_id"] as String? else null,
            callerPhone = if (json.has("caller_phone")) json["caller_phone"] as String? else null,
            callerName = if (json.has("caller_name")) json["caller_name"] as String? else null,
            hasVideo = if (json.has("has_video")) json["has_video"] as Boolean? else null
    )

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