package com.example.in_app_calls_demo.utils

import com.onesignal.OSNotification
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

object Notifications {
    @kotlin.Throws(JSONException::class)
    fun messageToJson(notification: OSNotification): Map<String, Any?> {
        val result = mutableMapOf<String, Any?>()

        result["androidNotificationId"] = notification.androidNotificationId

        if (!notification.groupedNotifications.isNullOrEmpty()) {
            val payloadJsonArray = JSONArray()
            for (groupedNotification: OSNotification in notification.groupedNotifications!!)
                payloadJsonArray.put(groupedNotification.toJSONObject())

            result["groupedNotifications"] = payloadJsonArray
        }

        result["notificationId"] = notification.notificationId
        result["title"] = notification.title

        if (notification.body != null)
            result["body"] = notification.body
        if (notification.smallIcon != null)
            result["smallIcon"] = notification.smallIcon
        if (notification.largeIcon != null)
            result["largeIcon"] = notification.largeIcon
        if (notification.bigPicture != null)
            result["bigPicture"] = notification.bigPicture
        if (notification.smallIconAccentColor != null)
            result["smallIconAccentColor"] = notification.smallIconAccentColor
        if (notification.launchURL != null)
            result["launchUrl"] = notification.launchURL
        if (notification.sound != null)
            result["sound"] = notification.sound
        if (notification.ledColor != null)
            result["ledColor"] = notification.ledColor
        result["lockScreenVisibility"] = notification.lockScreenVisibility
        if (notification.groupKey != null)
            result["groupKey"] = notification.groupKey
        if (notification.groupMessage != null)
            result["groupMessage"] = notification.groupMessage
        if (notification.fromProjectNumber != null)
            result["fromProjectNumber"] = notification.fromProjectNumber
        if (notification.collapseId != null)
            result["collapseId"] = notification.collapseId
        result["priority"] = notification.priority
        if (notification.additionalData != null && notification.additionalData.length() > 0)
            result["additionalData"] = convertJSONObjectToHashMap(notification.additionalData)
        if (notification.actionButtons != null && notification.actionButtons.isNotEmpty()) {
            val buttons = mutableListOf<Map<String, Any?>>()

            val actionButtons: List<OSNotification.ActionButton> = notification.actionButtons
            for (curAction in actionButtons) {
                val button: OSNotification.ActionButton = curAction

                val buttonHash = mutableMapOf<String, Any>()
                buttonHash["id"] = button.id
                buttonHash["text"] = button.text
                buttonHash["icon"] = button.icon
                buttons.add(buttonHash)
            }

            result["buttons"] = buttons
        }
        return result
    }


    @kotlin.Throws(JSONException::class)
    fun convertJSONObjectToHashMap(`object`: JSONObject?): HashMap<String?, Any?> {
        val hash: HashMap<String?, Any?> = HashMap()
        if (`object` == null || `object` === JSONObject.NULL) return hash
        val keys: Iterator<String> = `object`.keys()
        while (keys.hasNext()) {
            val key = keys.next()
            if (`object`.isNull(key)) continue
            var `val`: Any? = `object`.get(key)
            if (`val` is JSONArray) {
                `val` = convertJSONArrayToList(`val`)
            } else if (`val` is JSONObject) {
                `val` = convertJSONObjectToHashMap(`val` as JSONObject?)
            }
            hash[key] = `val`
        }
        return hash
    }

    @kotlin.Throws(JSONException::class)
    private fun convertJSONArrayToList(array: JSONArray): List<Any?> {
        val list = mutableListOf<Any>()
        for (i in 0 until array.length()) {
            var `val`: Any = array.get(i)
            if (`val` is JSONArray) `val` = convertJSONArrayToList(`val`) else if (`val` is JSONObject) `val` = convertJSONObjectToHashMap(`val`)
            list.add(`val`)
        }
        return list
    }
}