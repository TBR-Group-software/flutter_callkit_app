package com.example.in_app_calls_demo.notifications

import android.content.Context
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import com.example.in_app_calls_demo.connection_service.TelecomManagerHelper
import com.example.in_app_calls_demo.models.CallData
import com.example.in_app_calls_demo.utils.Constants
import com.onesignal.OSNotification
import com.onesignal.OSNotificationReceivedEvent
import com.onesignal.OneSignal.OSRemoteNotificationReceivedHandler
import com.vetsie.vetsie_pet_owner.utils.Notifications
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

@Suppress("unused")
class NotificationServiceExtension : OSRemoteNotificationReceivedHandler {
    companion object {
        private const val tag = "NotificationService"

        private const val notificationsChannel = "in_app_calls_demo/one_signal/notifications"
        private const val notificationMethod = "notification"
        private const val callInvitationNotificationMethod = "callInvitationNotification"

        private var notificationsMethodChannel: MethodChannel? = null

        fun configureNotificationsMethodChannel(flutterEngine: FlutterEngine) {
            notificationsMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, notificationsChannel)
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun remoteNotificationReceived(context: Context, notificationReceivedEvent: OSNotificationReceivedEvent) {
        val notification: OSNotification = notificationReceivedEvent.notification

        val data = notification.additionalData
        Log.i(tag, "Received Notification Data: $data")

        val notificationType = data["notificationType"]

        if (notificationType == Constants.CALL_INVITATION) {
            val telecomManager = TelecomManagerHelper(context)
            //TODO: add real call data
            val callData = CallData(callerId = "12345", channelId = "1", callerPhone = "+1 123 1234 12345", callerName = "Name Name", hasVideo = true)
            telecomManager.makeCall(callData)

            sendNotificationToMethodChannel(callInvitationNotificationMethod, notification)
            notificationReceivedEvent.complete(null)
            return
        } else {
            sendNotificationToMethodChannel(notificationMethod, notification)
        }

        notificationReceivedEvent.complete(notification)
    }

    private fun sendNotificationToMethodChannel(method: String, notification: OSNotification) {
        if (notificationsMethodChannel != null) {
            notificationsMethodChannel!!.invokeMethod(method, Notifications.messageToJson(notification))
        }
    }
}