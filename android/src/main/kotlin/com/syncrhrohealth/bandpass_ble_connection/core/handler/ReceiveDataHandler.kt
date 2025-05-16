package com.syncrhrohealth.bandpass_ble_connection.core.handler

import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.response.DeviceInfoRspHandler
import com.syncrhrohealth.bandpass_ble_connection.core.handler.response.ImuDataRspHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.Packet

val TAG: String = ReceiveDataHandler::class.java.simpleName

object ReceiveDataHandler {

    fun handle(packet: Packet, handler: DeviceHandler) {
        Log.d(TAG, "handle: ${packet.header.commandCode}")
        when (packet.header.commandCode) {

            /** Responses */

            CommandCode.PACKET_CMD_DEVICE_INFO_RESP -> {
                DeviceInfoRspHandler.handle(packet.data, handler)
            }

            CommandCode.PACKET_CMD_IMU_DATA_RSP -> {
                ImuDataRspHandler.handle(packet.data, handler)
            }

            else -> {
                Log.e(TAG, "Unknown command code: ${packet.header.commandCode}")
            }
        }
    }
}