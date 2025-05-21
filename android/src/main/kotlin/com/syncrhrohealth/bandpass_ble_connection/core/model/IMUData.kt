package com.syncrhrohealth.bandpass_ble_connection.core.model

data class IMUData(
    val count: Int,
    val accelX: Float,
    val accelY: Float,
    val accelZ: Float,
    val gyrosX: Float,
    val gyrosY: Float,
    val gyrosZ: Float,
    val adcRaw: Int,
    val timestampMs: Long
)
