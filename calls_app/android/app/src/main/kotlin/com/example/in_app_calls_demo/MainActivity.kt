package com.example.in_app_calls_demo

import android.os.Bundle
import com.example.in_app_calls_demo.notifications.NotificationServiceExtension
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private lateinit var callsApp: CallsApplication

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        callsApp = applicationContext as CallsApplication
        callsApp.setAppActivity(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NotificationServiceExtension.configureNotificationsMethodChannel(flutterEngine)
    }

    override fun onDestroy() {
        clearReferences()
        super.onDestroy()
    }

    private fun clearReferences() {
        val appActivity = callsApp.getAppActivity()
        if (this == appActivity) {
            callsApp.setAppActivity(null)
        }
    }
}
