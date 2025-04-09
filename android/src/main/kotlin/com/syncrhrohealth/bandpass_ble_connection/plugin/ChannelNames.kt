package com.syncrhrohealth.bandpass_ble_connection.plugin

/** Make sure this class matches the ChannelNames on the Flutter side */
object ChannelNames {
    // PREFIX
    private const val CHANNEL_PREFIX = "com.flutter.plugin"

    private const val METHOD = "method"
    private const val EVENT = "event"

    const val DEVICE_CORE_METHOD_CHANNEL = "$CHANNEL_PREFIX/$METHOD/device"
    const val DEVICE_CORE_EVENT_CHANNEL = "$CHANNEL_PREFIX/$EVENT/device"

    const val BLE_STATE_METHOD_CHANNEL   = "$CHANNEL_PREFIX/$METHOD/bluetooth_state"
    const val BLE_STATE_EVENT_CHANNEL = "$CHANNEL_PREFIX/$EVENT/bluetooth_state"
}
