package com.syncrhrohealth.bandpass_ble_connection.core.model

/**
 * One BLE IMU sample – field names & formats match the Python parser.
 *
 *  • Sensor values stay as `Float` so you can still do math/plots.
 *    (If you only need the prettified strings, change them to `String`.)
 *  • `adcRaw`, `date`, `timeMs` are nullable because the tags may be absent.
 */
data class IMUData(
    val count: Int,

    val accelX: Float,
    val accelY: Float,
    val accelZ: Float,

    val gyroX: Float,
    val gyroY: Float,
    val gyroZ: Float,

    val adcRaw: Int,

    /** `yyyy-MM-dd` in **UTC**; null if RTC tag missing            */
    val date: String,

    /** `HH:mm:ss.SSS` in **UTC**; null if RTC tag missing           */
    val timeMs: String
)
