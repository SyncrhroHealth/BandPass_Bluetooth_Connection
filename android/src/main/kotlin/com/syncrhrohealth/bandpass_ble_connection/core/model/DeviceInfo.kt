package com.syncrhrohealth.bandpass_ble_connection.core.model

data class DeviceInfo(
    val fwVersion: String,
    val hwVersion: String,
    val macAddress: String,
    val deviceName: String,
)