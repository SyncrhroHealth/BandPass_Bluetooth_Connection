package com.syncrhrohealth.bandpass_ble_connection.core.handler

import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.response.BasicInfoRspHandler
import com.syncrhrohealth.bandpass_ble_connection.core.handler.response.DeviceInfoRspHandler
import com.syncrhrohealth.bandpass_ble_connection.core.handler.response.DeviceNameRspHandler
import com.syncrhrohealth.bandpass_ble_connection.core.handler.response.HotBoxDataRspHandler
import com.syncrhrohealth.bandpass_ble_connection.core.handler.response.ScheduleRspHandler
import com.syncrhrohealth.bandpass_ble_connection.core.handler.response.TimeStampRspHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.Packet

val TAG: String = ReceiveDataHandler::class.java.simpleName

object ReceiveDataHandler {

    fun handle(packet: Packet, handler: DeviceHandler) {
        Log.d(TAG, "handle: ${packet.header.commandCode}")
        when (packet.header.commandCode) {

            /** Responses */

            CommandCode.PACKET_CMD_DEVICE_NAME_RESP -> {
                DeviceNameRspHandler.handle(packet.data, handler)
            }

            CommandCode.PACKET_CMD_DEVICE_INFO_RESP -> {
                DeviceInfoRspHandler.handle(packet.data, handler)
            }

            CommandCode.PACKET_CMD_BASIC_INFO_RESP -> {
                BasicInfoRspHandler.handle(packet.data, handler)
            }

            CommandCode.PACKET_CMD_HOTBOX_DATA_RESP -> {
                HotBoxDataRspHandler.handle(packet.data, handler)
            }

            CommandCode.PACKET_CMD_TIMESTAMP_RESP -> {
                TimeStampRspHandler.handle(packet.data, handler)
            }

            CommandCode.PACKET_CMD_SCHEDULE_RESP -> {
                ScheduleRspHandler.handle(packet.data, handler)
            }

            else -> {
                Log.e(TAG, "Unknown command code: ${packet.header.commandCode}")
            }
        }
    }
}