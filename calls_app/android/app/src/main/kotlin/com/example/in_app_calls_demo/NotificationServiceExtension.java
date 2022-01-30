package com.example.in_app_calls_demo;

import android.content.Context;
import android.util.Log;

import org.json.JSONObject;

import com.onesignal.OSNotification;
import com.onesignal.OSNotificationReceivedEvent;
import com.onesignal.OneSignal.OSRemoteNotificationReceivedHandler;

@SuppressWarnings("unused")
public class NotificationServiceExtension implements OSRemoteNotificationReceivedHandler {

    @Override
    public void remoteNotificationReceived(Context context, OSNotificationReceivedEvent notificationReceivedEvent) {
        OSNotification notification = notificationReceivedEvent.getNotification();

        JSONObject data = notification.getAdditionalData();
        Log.i("OneSignalExample", "Received Notification Data: " + data);

        notificationReceivedEvent.complete(notification);
    }
}