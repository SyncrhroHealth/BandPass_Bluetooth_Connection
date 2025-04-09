package com.syncrhrohealth.bandpass_ble_connection.core.handler.response

import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.HotBoxData
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** Data format
 *
 *  uint8_t         fuel_level
 *  uint16_t        fan_speed
 *  uint16_t        pump_rate
 *  uint16_t        glow_plug_power
 *  uint16_t        sea_level
 *  float           battery_voltage
 *  float           heater_temperature
 *  float           fuel_capacity
 *  float           fuel_pump
 *  float           temperature_offset
 *
 * */

object HotBoxDataRspHandler {
    fun handle(data: ByteArray, handler: DeviceHandler) {
        Log.e(HotBoxDataRspHandler.javaClass.simpleName, "data len: ${data.size} ${data.toList()}")
        try {
//            if (data.size < 29) {
//                // Not enough data
//                return
//            }

            // 1) fuel_level (1 byte, index 0)
            val fuelLevel = data[0].toInt() and 0xFF

            // 2) fan_speed (2 bytes, indices 1..2)
            val fanSpeed = ByteBuffer.wrap(data, 1, 2)
                .order(ByteOrder.LITTLE_ENDIAN)
                .short
                .toInt() and 0xFFFF  // interpret as unsigned

            // 3) pump_rate (2 bytes, indices 3..4)
            val pumpRate = ByteBuffer.wrap(data, 3, 2)
                .order(ByteOrder.LITTLE_ENDIAN)
                .short
                .toInt() and 0xFFFF

            // 4) glow_plug_power (2 bytes, indices 5..6)
            val glowPlugPower = ByteBuffer.wrap(data, 5, 2)
                .order(ByteOrder.LITTLE_ENDIAN)
                .short
                .toInt() and 0xFFFF

            // 5) sea_level (2 bytes, indices 7..8)
            val seaLevel = ByteBuffer.wrap(data, 7, 2)
                .order(ByteOrder.LITTLE_ENDIAN)
                .short
                .toInt() and 0xFFFF

            // 6) battery_voltage (float, 4 bytes, indices 9..12)
            val batteryVoltage = ByteBuffer.wrap(data, 9, 4)
                .order(ByteOrder.LITTLE_ENDIAN)
                .float

            // 7) heater_temperature (float, 4 bytes, indices 13..16)
            val heaterTemperature = ByteBuffer.wrap(data, 13, 4)
                .order(ByteOrder.LITTLE_ENDIAN)
                .float

            // 8) fuel_capacity (float, 4 bytes, indices 17..20)
            val fuelCapacity = ByteBuffer.wrap(data, 17, 4)
                .order(ByteOrder.LITTLE_ENDIAN)
                .float

            // 9) fuel_pump (float, 4 bytes, indices 21..24)
            val fuelPump = ByteBuffer.wrap(data, 21, 4)
                .order(ByteOrder.LITTLE_ENDIAN)
                .float

            // 10) temperature_offset (float, 4 bytes, indices 25..28)
            val temperatureOffset = ByteBuffer.wrap(data, 25, 4)
                .order(ByteOrder.LITTLE_ENDIAN)
                .float

            // Build your data object
            val hotBoxData = HotBoxData(
                fuelLevel = fuelLevel,
                fanSpeed = fanSpeed,
                pumpRate = pumpRate,
                glowPlugPower = glowPlugPower,
                seaLevel = seaLevel,
                batteryVoltage = batteryVoltage,
                heaterTemp = heaterTemperature,
                fuelCapacity = fuelCapacity,
                fuelPump = fuelPump,
                tempOffset = temperatureOffset
            )

            Log.e(HotBoxDataRspHandler.javaClass.simpleName, "handle: ",)
            handler.callBack.onHotBoxDataRsp(hotBoxData, handler)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}