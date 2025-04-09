package com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.event

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel


class DeviceCoreEventHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    fun send(task: DeviceCoreEventTask) {
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf(
                "event" to task.event,
                "body" to task.data
            ))
        }
    }

    fun send(event: String, body: Map<String, Any>?) {
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf("event" to event, "body" to body))
        }
    }

    fun send(event: String, body: ArrayList<HashMap<String, String>>) {
        Handler(Looper.getMainLooper()).post {
            eventSink?.success(mapOf("event" to event, "body" to body))
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}