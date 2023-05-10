package com.example.in_app_calls_demo.notifications

import android.content.Context
import android.util.Log
import com.example.in_app_calls_demo.connection_service.TelecomManagerHelper
import com.example.in_app_calls_demo.models.CallData
import com.example.in_app_calls_demo.utils.Constants
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

        val notificationType = data["notificationType"]

        if (notificationType == Constants.CALL_INVITATION) {
            val telecomManager = TelecomManagerHelper(context)
            //TODO: add real call data
            val callData = CallData(callerId = "12345", channelId = "1", callerPhone = "+1 123 1234 12345", callerName = "Name Name", hasVideo = true)
            telecomManager.makeCall(callData)

            // Doesn't show the notification if it was CALL_INVITATION
            notificationReceivedEvent.complete(null)
            return
        }

        notificationReceivedEvent.complete(notification)
    }
}