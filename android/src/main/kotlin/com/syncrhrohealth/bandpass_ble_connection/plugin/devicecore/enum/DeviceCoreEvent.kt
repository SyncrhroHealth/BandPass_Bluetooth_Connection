package com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.enum

/** Make sure the event value matches the DeviceCoreEvent on Flutter side */
enum class DeviceCoreEvent(val value: String) {
    // Connection
    ON_DEVICE_FOUND("onDeviceFound"),
    ON_DEVICE_CONNECTED("onDeviceConnected"),
    ON_DEVICE_DISCONNECTED("onDeviceDisconnected"),

    // Data response
    ON_DEVICE_INFO_RSP("onDeviceInfoRsp"),
    ON_IMU_DATA_RSP("onImuDataRsp"),
}
