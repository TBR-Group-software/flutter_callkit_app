package com.example.in_app_calls_demo

import android.content.Context
import android.util.Log
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

    override fun remoteNotificationReceived(context: Context, notificationReceivedEvent: OSNotificationReceivedEvent) {
        val notification: OSNotification = notificationReceivedEvent.notification

        val data = notification.additionalData
        Log.i(tag, "Received Notification Data: $data")

        if (notificationsMethodChannel != null) {
            if (data["notificationType"] == Constants.CALL_INVITATION) {
                notificationsMethodChannel!!.invokeMethod(callInvitationNotificationMethod, Notifications.messageToJson(notification))
                notificationReceivedEvent.complete(null)
                return
            } else {
                notificationsMethodChannel!!.invokeMethod(notificationMethod, Notifications.messageToJson(notification))
            }
        }

        notificationReceivedEvent.complete(notification)
    }

}