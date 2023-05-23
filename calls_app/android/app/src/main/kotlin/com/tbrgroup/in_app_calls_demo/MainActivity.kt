package com.tbrgroup.in_app_calls_demo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private lateinit var callsApp: CallsApplication

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        callsApp = applicationContext as CallsApplication
        callsApp.setAppActivity(this)
        callsApp.configureWithFlutterEngine(flutterEngine)
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
        callsApp.clearBackgroundCallData()
    }
}
