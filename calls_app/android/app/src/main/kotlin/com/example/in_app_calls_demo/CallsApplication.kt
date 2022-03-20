package com.example.in_app_calls_demo

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.util.Log
import android.view.WindowManager
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import androidx.lifecycle.ProcessLifecycleOwner
import com.example.in_app_calls_demo.models.CallData
import com.example.in_app_calls_demo.utils.Constants
import io.flutter.app.FlutterApplication

@Suppress("unused")
class CallsApplication : FlutterApplication(), LifecycleObserver {
    companion object {
        private const val tag = "CallsApplication"
    }

    private var applicationState: Lifecycle.Event? = null
    private var appActivity: Activity? = null

    fun getApplicationState() = applicationState

    fun getAppActivity() = appActivity

    fun setAppActivity(activity: Activity?) {
        appActivity = activity
    }

    override fun onCreate() {
        super.onCreate()
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    fun onAppForegrounded() {
        applicationState = Lifecycle.Event.ON_START
        Log.d(tag, "Lifecycle.Event.ON_START")
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onAppBackgrounded() {
        applicationState = Lifecycle.Event.ON_STOP
        Log.d(tag, "Lifecycle.Event.ON_STOP")
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    fun onAppDestroyed() {
        applicationState = Lifecycle.Event.ON_DESTROY
        Log.d(tag, "Lifecycle.Event.ON_DESTROY")
    }

    @SuppressLint("WrongConstant")
    fun backToForeground() {
        val packageName = applicationContext.packageName
        val focusIntent = applicationContext.packageManager.getLaunchIntentForPackage(packageName)!!.cloneFilter()
        val activity = appActivity
        val isOpened = activity != null
        Log.d(tag, "backToForeground, app isOpened ?" + if (isOpened) "true" else "false")
        if (isOpened) {
            focusIntent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
            activity!!.startActivity(focusIntent)
        } else {
            focusIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK +
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED +
                    WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD +
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
            if (activity != null) {
                activity.startActivity(focusIntent)
            } else {
                applicationContext.startActivity(focusIntent)
            }
        }
    }

    fun startMainActivityWithCallData(callData: CallData) {
        val intent = Intent(applicationContext, MainActivity::class.java)
        intent.putExtra(Constants.CALL_DATA, callData)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        applicationContext.startActivity(intent)
    }
}