package com.syncrhrohealth.bandpass_ble_connection.core.model

data class IMUData(
    val count: Int,
    val accel: Vec3Batch,
    val gyro:  Vec3Batch,
    val adcRaw: Int,
    val timestampMs: Long
)
