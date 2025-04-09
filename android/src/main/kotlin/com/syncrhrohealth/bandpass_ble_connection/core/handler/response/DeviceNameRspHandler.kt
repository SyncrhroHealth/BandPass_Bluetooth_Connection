package com.syncrhrohealth.bandpass_ble_connection.core.handler.response

import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** Data format
 *
 *  char[20]       name
 *
 * */

object DeviceNameRspHandler {
    fun handle(data: ByteArray, handler: DeviceHandler) {
        try {
            // Convert those 20 bytes (assuming ASCII or UTF-8) to a string
            // .trimEnd('\u0000') removes trailing nulls, in case the name was padded.
            val deviceName = data
                .copyOfRange(0, 20)
                .toString(Charsets.US_ASCII)
                .trimEnd('\u0000')

            handler.callBack.onDeviceNameRsp(deviceName, handler)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}