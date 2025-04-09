package com.syncrhrohealth.bandpass_ble_connection.core.enum

import android.util.Log

enum class CommandCode {
    PACKET_CMD_DEVICE_NAME_SET,
    PACKET_CMD_DEVICE_NAME_GET,
    PACKET_CMD_DEVICE_NAME_RESP,
    PACKET_CMD_DEVICE_INFO_GET,
    PACKET_CMD_DEVICE_INFO_RESP,
    PACKET_CMD_MODE_THERMOSTAT_CONTROL_SET,
    PACKET_CMD_MODE_MANUAL_CONTROL_SET,
    PACKET_CMD_BASIC_INFO_GET,
    PACKET_CMD_BASIC_INFO_RESP,
    PACKET_CMD_HOTBOX_DATA_GET,
    PACKET_CMD_HOTBOX_DATA_RESP,
    PACKET_CMD_TIMESTAMP_SET,
    PACKET_CMD_TIMESTAMP_GET,
    PACKET_CMD_TIMESTAMP_RESP,
    PACKET_CMD_SCHEDULE_SET,
    PACKET_CMD_SCHEDULE_GET,
    PACKET_CMD_SCHEDULE_RESP,
    PACKET_CMD_RESET_FUEL_LEVEL_SET,
    PACKET_CMD_FUEL_CAPACITY_SET,
    PACKET_CMD_FUEL_PUMP_SET,
    PACKET_CMD_SEA_LEVEL_SET,
    PACKET_CMD_TEMPERATURE_OFFSET_SET,
    PACKET_CMD_OTA_START,
    PACKET_CMD_OTA_WRITE,
    PACKET_CMD_OTA_WRITE_AND_UPDATE;

    fun getValue(): Byte {
        return when (this) {
            PACKET_CMD_DEVICE_NAME_SET             -> 1
            PACKET_CMD_DEVICE_NAME_GET             -> 2
            PACKET_CMD_DEVICE_NAME_RESP            -> 3
            PACKET_CMD_DEVICE_INFO_GET             -> 4
            PACKET_CMD_DEVICE_INFO_RESP            -> 5
            PACKET_CMD_MODE_THERMOSTAT_CONTROL_SET -> 6
            PACKET_CMD_MODE_MANUAL_CONTROL_SET     -> 7
            PACKET_CMD_BASIC_INFO_GET              -> 8
            PACKET_CMD_BASIC_INFO_RESP             -> 9
            PACKET_CMD_HOTBOX_DATA_GET             -> 10
            PACKET_CMD_HOTBOX_DATA_RESP            -> 11
            PACKET_CMD_TIMESTAMP_SET               -> 12
            PACKET_CMD_TIMESTAMP_GET               -> 13
            PACKET_CMD_TIMESTAMP_RESP              -> 14
            PACKET_CMD_SCHEDULE_SET                -> 15
            PACKET_CMD_SCHEDULE_GET                -> 16
            PACKET_CMD_SCHEDULE_RESP               -> 17
            PACKET_CMD_RESET_FUEL_LEVEL_SET        -> 18
            PACKET_CMD_FUEL_CAPACITY_SET           -> 19
            PACKET_CMD_FUEL_PUMP_SET               -> 20
            PACKET_CMD_SEA_LEVEL_SET               -> 21
            PACKET_CMD_TEMPERATURE_OFFSET_SET      -> 22
            PACKET_CMD_OTA_START                   -> 23
            PACKET_CMD_OTA_WRITE                   -> 24
            PACKET_CMD_OTA_WRITE_AND_UPDATE        -> 25
        }.toByte()
    }

    companion object {
        private val TAG: String = CommandCode::class.java.simpleName

        fun fromValue(value: Int): CommandCode? {
            return when (value) {
                1  -> PACKET_CMD_DEVICE_NAME_SET
                2  -> PACKET_CMD_DEVICE_NAME_GET
                3  -> PACKET_CMD_DEVICE_NAME_RESP
                4  -> PACKET_CMD_DEVICE_INFO_GET
                5  -> PACKET_CMD_DEVICE_INFO_RESP
                6  -> PACKET_CMD_MODE_THERMOSTAT_CONTROL_SET
                7  -> PACKET_CMD_MODE_MANUAL_CONTROL_SET
                8  -> PACKET_CMD_BASIC_INFO_GET
                9  -> PACKET_CMD_BASIC_INFO_RESP
                10 -> PACKET_CMD_HOTBOX_DATA_GET
                11 -> PACKET_CMD_HOTBOX_DATA_RESP
                12 -> PACKET_CMD_TIMESTAMP_SET
                13 -> PACKET_CMD_TIMESTAMP_GET
                14 -> PACKET_CMD_TIMESTAMP_RESP
                15 -> PACKET_CMD_SCHEDULE_SET
                16 -> PACKET_CMD_SCHEDULE_GET
                17 -> PACKET_CMD_SCHEDULE_RESP
                18 -> PACKET_CMD_RESET_FUEL_LEVEL_SET
                19 -> PACKET_CMD_FUEL_CAPACITY_SET
                20 -> PACKET_CMD_FUEL_PUMP_SET
                21 -> PACKET_CMD_SEA_LEVEL_SET
                22 -> PACKET_CMD_TEMPERATURE_OFFSET_SET
                23 -> PACKET_CMD_OTA_START
                24 -> PACKET_CMD_OTA_WRITE
                25 -> PACKET_CMD_OTA_WRITE_AND_UPDATE
                else -> {
                    Log.e(TAG, "fromValue: Invalid Request code value: $value")
                    null
                }
            }
        }
    }
}

//enum class CommandCode(val value: Byte) {
//    PACKET_CMD_DEVICE_NAME_SET(1),
//    PACKET_CMD_DEVICE_NAME_GET(2),
//    PACKET_CMD_DEVICE_NAME_RESP(3),
//    PACKET_CMD_DEVICE_INFO_GET(4),
//    PACKET_CMD_DEVICE_INFO_RESP(5),
//    PACKET_CMD_MODE_THERMOSTAT_CONTROL_SET(6),
//    PACKET_CMD_MODE_MANUAL_CONTROL_SET(7),
//    PACKET_CMD_BASIC_INFO_GET(8),
//    PACKET_CMD_BASIC_INFO_RESP(9),
//    PACKET_CMD_HOTBOX_DATA_GET(10),
//    PACKET_CMD_HOTBOX_DATA_RESP(11),
//    PACKET_CMD_TIMESTAMP_SET(12),
//    PACKET_CMD_TIMESTAMP_GET(13),
//    PACKET_CMD_TIMESTAMP_RESP(14),
//    PACKET_CMD_SCHEDULE_SET(15),
//    PACKET_CMD_SCHEDULE_GET(16),
//    PACKET_CMD_SCHEDULE_RESP(17),
//    PACKET_CMD_RESET_FUEL_LEVEL_SET(18),
//    PACKET_CMD_FUEL_CAPACITY_SET(19),
//    PACKET_CMD_FUEL_PUMP_SET(20),
//    PACKET_CMD_SEA_LEVEL_SET(21),
//    PACKET_CMD_TEMPERATURE_OFFSET_SET(22),
//    PACKET_CMD_OTA_START(23),
//    PACKET_CMD_OTA_WRITE(24),
//    PACKET_CMD_OTA_WRITE_AND_UPDATE(25);
//
//    companion object {
//        private const val TAG = "CommandCode"
//
//        fun fromValue(value: Int): CommandCode? {
//            return entries.find { it.value.toInt() == value } ?: run {
//                Log.e(TAG, "fromValue: Invalid Request code value: $value")
//                null
//            }
//        }
//    }
//}
