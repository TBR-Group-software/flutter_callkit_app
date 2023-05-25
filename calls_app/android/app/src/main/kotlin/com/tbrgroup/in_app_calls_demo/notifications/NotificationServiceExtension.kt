package com.tbrgroup.in_app_calls_demo.notifications

import android.content.Context
import android.util.Log
import com.tbrgroup.in_app_calls_demo.connection_service.TelecomManagerHelper
import com.tbrgroup.in_app_calls_demo.models.CallData
import com.tbrgroup.in_app_calls_demo.utils.Constants
import com.onesignal.OSNotificationReceivedEvent
import com.onesignal.OneSignal.OSRemoteNotificationReceivedHandler

@Suppress("unused")
class NotificationServiceExtension : OSRemoteNotificationReceivedHandler {
    companion object {
        private const val tag = "NotificationService"
    }

    override fun remoteNotificationReceived(context: Context, notificationReceivedEvent: OSNotificationReceivedEvent) {
        val notification = notificationReceivedEvent.notification

        val data = notification.additionalData
        Log.i(tag, "Received Notification Data: $data")
        val notificationType = data.optString("notification_type")

        if (notificationType == Constants.CALL_INVITATION) {
            val telecomManager = TelecomManagerHelper(context)
            val callData = CallData(data)
            telecomManager.makeCall(callData)

            // Prevents the notification from being shown if it was a CALL_INVITATION
            notificationReceivedEvent.complete(null)
            return
        }

        notificationReceivedEvent.complete(notification)
    }
}