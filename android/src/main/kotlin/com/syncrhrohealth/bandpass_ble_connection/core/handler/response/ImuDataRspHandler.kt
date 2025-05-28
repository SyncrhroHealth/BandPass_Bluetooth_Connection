package com.syncrhrohealth.bandpass_ble_connection.core.handler.response

import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.IMUData
import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * IMU Data Response Handler
 *
 * Parses the raw payload (including the single-byte type) into IMUData, using
 * integer and fractional components for each sensor reading (as in Python reference).fileciteturn12file1
 *
 * Data format (Packet.data):
 * Byte 0      : Payload type tag (0x03 = IMU data)
 * Byte 1–2    : Count (big-endian format)
 * Byte 3–10   : Accelerometer X (int32 LE integer + int32 LE fractional parts)
 * Byte 11–18  : Accelerometer Y (int32 LE integer + int32 LE fractional parts)
 * Byte 19–26  : Accelerometer Z (int32 LE integer + int32 LE fractional parts)
 * Byte 27–34  : Gyroscope X (int32 LE integer + int32 LE fractional parts)
 * Byte 35–42  : Gyroscope Y (int32 LE integer + int32 LE fractional parts)
 * Byte 43–50  : Gyroscope Z (int32 LE integer + int32 LE fractional parts)
 * Byte 51     : ADC tag (0x02)
 * Byte 52–53  : ADC raw value (big-endian uint16)
 * Byte 54     : RTC tag (0x04)
 * Byte 55–58  : RTC seconds (big-endian uint32)
 * Byte 59–60  : RTC milliseconds (big-endian uint16)
 * Byte 61     : Optional terminator tag – discard if present
 */
object ImuDataRspHandler {
    private const val TAG = "ImuDataRspHandler"

    fun handle(data: ByteArray, handler: DeviceHandler) {
        Log.d(TAG, "handle: len=${data.size}, bytes=${data.toList()}")
        try {
            // 0: payload type
            require(data[0] == 0x03.toByte()) { "Invalid payload type: ${data[0]}" }

            // 1–2: count (big-endian)
            val count = ((data[1].toInt() and 0xFF) shl 8) or
                    (data[2].toInt() and 0xFF)

            // wrap for little-endian multi-byte reads
            val bb = ByteBuffer.wrap(data).order(ByteOrder.LITTLE_ENDIAN)
            // Parse sensor value: 32-bit integer part + 32-bit fractional part (1e6 scale)
            fun parseSensor(offset: Int): Float {
                val intPart = bb.getInt(offset)
                val fracPart = bb.getInt(offset + 4)
                return intPart + fracPart / 1_000_000f
            }

            // Accelerometer (first sample)
            val accelX = parseSensor(3)
            val accelY = parseSensor(11)
            val accelZ = parseSensor(19)

            // Gyroscope (first sample)
            val gyroX  = parseSensor(27)
            val gyroY  = parseSensor(35)
            val gyroZ  = parseSensor(43)

            // ADC: tag + big-endian uint16
            require(data[51] == 0x02.toByte()) { "Invalid ADC tag: ${data[51]}" }
            val adcRaw = ((data[52].toInt() and 0xFF) shl 8) or
                    (data[53].toInt() and 0xFF)

            // RTC: tag, seconds (uint32 BE), milliseconds (uint16 BE)
            require(data[54] == 0x04.toByte()) { "Invalid RTC tag: ${data[54]}" }
            val secs = ((data[55].toInt() and 0xFF) shl 24) or
                    ((data[56].toInt() and 0xFF) shl 16) or
                    ((data[57].toInt() and 0xFF) shl 8) or
                    (data[58].toInt() and 0xFF)
            val ms   = ((data[59].toInt() and 0xFF) shl 8) or
                    (data[60].toInt() and 0xFF)
            val timestampMs = secs * 1000L + ms

            // Build and dispatch IMUData model
            val imuData = IMUData(
                count,
                accelX, accelY, accelZ,
                gyroX, gyroY, gyroZ,
                adcRaw,
                timestampMs
            )
//            Log.d(TAG, "imuData: $imuData")

            handler.callBack.onImuDataRsp(imuData, handler)
        } catch (e: Exception) {
            Log.e(TAG, "Parsing error", e)
        }
    }
}
