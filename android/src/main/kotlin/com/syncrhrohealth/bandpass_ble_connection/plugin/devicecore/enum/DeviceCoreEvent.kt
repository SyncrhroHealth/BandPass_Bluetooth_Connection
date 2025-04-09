package com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.enum

/** Make sure the event value matches the DeviceCoreEvent on Flutter side */
enum class DeviceCoreEvent(val value: String) {
    // Connection
    ON_DEVICE_FOUND("onDeviceFound"),
    ON_DEVICE_CONNECTED("onDeviceConnected"),
    ON_DEVICE_DISCONNECTED("onDeviceDisconnected"),

    // Data response
    ON_DEVICE_NAME_RSP("onDeviceNameRsp"),
    ON_DEVICE_INFO_RSP("onDeviceInfoRsp"),
    ON_BASIC_INFO_RSP("onBasicInfoRsp"),
    ON_HOT_BOX_DATA_RSP("onHotBoxDataRsp"),
    ON_TIME_STAMP_RSP("onTimeStampRsp"),
    ON_SCHEDULE_RSP("onScheduleRsp"),
}
