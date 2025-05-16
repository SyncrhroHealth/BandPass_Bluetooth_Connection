package com.syncrhrohealth.bandpass_ble_connection.core.enum

import android.util.Log

enum class CommandCode {

    PACKET_CMD_DEVICE_INFO_GET,
    PACKET_CMD_DEVICE_INFO_RESP,
    PACKET_CMD_IMU_DATA_RSP;

    fun getValue(): Byte {
        return when (this) {
            PACKET_CMD_DEVICE_INFO_GET             -> 1
            PACKET_CMD_DEVICE_INFO_RESP            -> 2
            PACKET_CMD_IMU_DATA_RSP        -> 3
        }.toByte()
    }

    companion object {
        private val TAG: String = CommandCode::class.java.simpleName

        fun fromValue(value: Int): CommandCode? {
            return when (value) {
                1  -> PACKET_CMD_DEVICE_INFO_GET
                2  -> PACKET_CMD_DEVICE_INFO_RESP
                3 -> PACKET_CMD_IMU_DATA_RSP
                else -> {
                    Log.e(TAG, "fromValue: Invalid Request code value: $value")
                    null
                }
            }
        }
    }
}
