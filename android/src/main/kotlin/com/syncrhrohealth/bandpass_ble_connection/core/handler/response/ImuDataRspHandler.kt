package com.syncrhrohealth.bandpass_ble_connection.core.handler.response

import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.IMUData
import com.syncrhrohealth.bandpass_ble_connection.core.model.Vec3Batch
import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * IMU Data Response Handler
 *
 * Parses the raw payload (excluding the single-byte headerType) into IMUData:
 *
 * Data format (Packet.data):
 * Byte 0–1   : Count (big-endian format)
 * Byte 2–25  : Accelerometer batch (24 bytes) – 4 samples of X,Y,Z each (int16 LE)
 * Byte 26–49 : Gyroscope batch (24 bytes)     – 4 samples of X,Y,Z each (int16 LE)
 * Byte 50    : ADC tag (0x02)
 * Byte 51–52 : ADC raw value (uint16 LE, 0–1023)
 * Byte 53–58 : RTC timestamp (48-bit little-endian ms since 2000-01-01)
 * Byte 59    : Optional terminator tag (0x04) – discard if present
 */
object ImuDataRspHandler {
    fun handle(data: ByteArray, handler: DeviceHandler) {
        Log.d(ImuDataRspHandler.javaClass.simpleName, "handle: len=${data.size}, bytes=${data.toList()}")
        try {
            // wrap in little-endian buffer
            val bb = ByteBuffer.wrap(data).order(ByteOrder.LITTLE_ENDIAN)

            // 0–1: count (big-endian)
            val count = ((data[0].toInt() and 0xFF) shl 8) or (data[1].toInt() and 0xFF)

            // 2–25: accel batch
            val accelXs = ShortArray(4) { bb.getShort(2 + it * 6) }
            val accelYs = ShortArray(4) { bb.getShort(4 + it * 6) }
            val accelZs = ShortArray(4) { bb.getShort(6 + it * 6) }

            // 26–49: gyro batch
            val gyroXs  = ShortArray(4) { bb.getShort(26 + it * 6) }
            val gyroYs  = ShortArray(4) { bb.getShort(28 + it * 6) }
            val gyroZs  = ShortArray(4) { bb.getShort(30 + it * 6) }

            // 50: ADC tag
            require(data[50] == 0x02.toByte()) { "Invalid ADC tag: ${data[50]}" }

            // 51–52: adcRaw
            val adcRaw = bb.getShort(51).toInt() and 0xFFFF

            // 53–58: rtc timestamp
            val low      = bb.getInt(53).toLong() and 0xFFFFFFFFL
            val high     = (bb.getShort(57).toLong() and 0xFFFFL) shl 32
            val timestampMs = high or low

            // build data objects
            val accelBatch = Vec3Batch(accelXs, accelYs, accelZs)
            val gyroBatch  = Vec3Batch(gyroXs,  gyroYs,  gyroZs)
            val imuData    = IMUData(count, accelBatch, gyroBatch, adcRaw, timestampMs)
            Log.d(ImuDataRspHandler.javaClass.simpleName, "imuData: $imuData")

            // callback to handler
            handler.callBack.onImuDataRsp(imuData, handler)
        } catch (e: Exception) {
            Log.e(ImuDataRspHandler.javaClass.simpleName, "Parsing error", e)
        }
    }
}
