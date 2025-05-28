package com.syncrhrohealth.bandpass_ble_connection.core.handler

import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.core.handler.response.ImuDataRspHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.Packet

val TAG: String = ReceiveDataHandler::class.java.simpleName

object ReceiveDataHandler {

    fun handle(packet: Packet, handler: DeviceHandler) {
//        Log.d(TAG, "handle: ${packet.header.type}")

        val typeInt = packet.header.type.toInt() and 0xFF
        when (typeInt) {
            /** Responses */
            0x03 -> {
                ImuDataRspHandler.handle(packet.data, handler)
            }

            else -> {
                Log.e(TAG, "Unknown header type: ${packet.header.type}")
            }
        }
    }
}