package com.syncrhrohealth.bandpass_ble_connection.core.handler.response

import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.BasicInfo
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** Data format
 *
 *  uint8_t     temperature_sensor_is_attached      (0: Not attached; 1: Attached)
 *  uint8_t     device_operation_mode               (0: Thermostat; 1: Manual)
 *  uint8_t     mode_thermostat_state               (0: Idle; 1: Running)
 *  uint8_t     mode_manual_state                   (0: Idle; 1: Running)
 *  uint8_t     fuel_level                          (0: 100)
 *  uint8_t     current_level                       (1 to 5)
 *  uint8_t     expected_level                      (1 to 5)
 *  float       current_temperature
 *  float       expected_temperature
 *
 * */

object BasicInfoRspHandler {
    fun handle(data: ByteArray, handler: DeviceHandler) {
        try {
            if (data.size < 15) {
                // Not enough bytes to parse
                return
            }

            val temperatureSensorAttached = (data[0].toInt() and 0xFF)
            val deviceOperationMode       = (data[1].toInt() and 0xFF)
            val modeThermostatState       = (data[2].toInt() and 0xFF)
            val modeManualState           = (data[3].toInt() and 0xFF)
            val fuelLevel                 = (data[4].toInt() and 0xFF)
            val currentLevel              = (data[5].toInt() and 0xFF)
            val expectedLevel             = (data[6].toInt() and 0xFF)

            val currentTemperature = ByteBuffer.wrap(data, 7, 4)
                .order(ByteOrder.LITTLE_ENDIAN)
                .float

            val expectedTemperature = ByteBuffer.wrap(data, 11, 4)
                .order(ByteOrder.LITTLE_ENDIAN)
                .float

            val basicInfo = BasicInfo(
                isTempSensorAttached = temperatureSensorAttached,
                deviceOperationMode = deviceOperationMode,
                modeThermostatState = modeThermostatState,
                modeManualState = modeManualState,
                fuelLevel = fuelLevel,
                currentLevel = currentLevel,
                expectedLevel = expectedLevel,
                currentTemp = currentTemperature,
                expectedTemp = expectedTemperature
            )

            handler.callBack.onBasicInfoRsp(basicInfo, handler)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}