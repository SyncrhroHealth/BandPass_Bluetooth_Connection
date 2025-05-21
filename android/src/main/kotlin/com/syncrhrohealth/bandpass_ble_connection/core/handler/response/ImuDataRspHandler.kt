package com.syncrhrohealth.bandpass_ble_connection.core.handler.response

import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.IMUData
import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * IMU Data Response Handler
 *
 * Parses the raw payload (including the single-byte type) into IMUData:
 *
 * Data format (Packet.data):
 * Byte 0      : Payload type tag (0x03 = IMU data)
 * Byte 1–2    : Count (big-endian format)
 * Byte 3–10   : Accelerometer X (int32 LE integer + int32 LE fractional parts)
 * Byte 11–18  : Accelerometer Y (same format)
 * Byte 19–26  : Accelerometer Z (same format)
 * Byte 27–34  : Gyroscope X (int32 LE + frac)
 * Byte 35–42  : Gyroscope Y (int32 LE + frac)
 * Byte 43–50  : Gyroscope Z (int32 LE + frac)
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

            // wrap for LE int32 reads
            val bb = ByteBuffer.wrap(data).order(ByteOrder.LITTLE_ENDIAN)
            fun parseSensor(offset: Int): Float {
                val intPart = bb.getInt(offset)
                val fracPart = bb.getInt(offset + 4)
                return intPart + fracPart / 1_000_000f
            }

            // accel: offsets 3, 11, 19
            val accelX = parseSensor(3)
            val accelY = parseSensor(11)
            val accelZ = parseSensor(19)

            // gyro: offsets 27, 35, 43
            val gyroX  = parseSensor(27)
            val gyroY  = parseSensor(35)
            val gyroZ  = parseSensor(43)

            // ADC: tag then big-endian uint16
            var adcRaw = 0
            if (data.getOrNull(51) == 0x02.toByte()) {
                adcRaw = ((data[52].toInt() and 0xFF) shl 8) or
                        (data[53].toInt() and 0xFF)
            } else {
                Log.w(TAG, "Unexpected ADC tag ${data.getOrNull(51)}")
            }

            // RTC: tag, seconds, ms (big-endian)
            var timestampMs = 0L
            if (data.getOrNull(54) == 0x04.toByte()) {
                val secs = ((data[55].toInt() and 0xFF) shl 24) or
                        ((data[56].toInt() and 0xFF) shl 16) or
                        ((data[57].toInt() and 0xFF) shl 8)  or
                        (data[58].toInt() and 0xFF)
                val ms   = ((data[59].toInt() and 0xFF) shl 8) or
                        (data[60].toInt() and 0xFF)
                timestampMs = secs * 1000L + ms
            } else {
                Log.w(TAG, "Unexpected RTC tag ${data.getOrNull(54)}")
            }

            // build and dispatch IMUData model
            val imuData = IMUData(
                count,
                accelX, accelY, accelZ,
                gyroX, gyroY, gyroZ,
                adcRaw,
                timestampMs
            )
            handler.callBack.onImuDataRsp(imuData, handler)

        } catch (e: Exception) {
            Log.e(TAG, "Parsing error", e)
        }
    }
}
