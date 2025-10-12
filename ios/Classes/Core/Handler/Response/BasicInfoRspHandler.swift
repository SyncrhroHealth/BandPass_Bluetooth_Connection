//
//  BasicInfoRspHandler.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `uint8_t temperature_sensor_is_attached` (0: Not attached; 1: Attached)
/// - `uint8_t device_operation_mode` (0: Thermostat; 1: Manual)
/// - `uint8_t mode_thermostat_state` (0: Idle; 1: Running)
/// - `uint8_t mode_manual_state` (0: Idle; 1: Running)
/// - `uint8_t run_state` (0: Idle; 1: Running)
/// - `uint8_t fuel_level` (0–100)
/// - `uint8_t current_level` (1–5)
/// - `uint8_t expected_level` (1–5)
/// - `float current_temperature` (4 bytes, little‑endian)
/// - `float expected_temperature` (4 bytes, little‑endian)

struct BasicInfoRspHandler {
    static func handle(data: Data, handler: DeviceHandler) {
        // 5 bytes for flags + 3 bytes for levels + 8 bytes for two floats = 16 bytes
        guard data.count >= 16 else {
            // Not enough bytes to parse
            return
        }

        // Read the six flags/levels
        let temperatureSensorAttached = Int(data[0])
        let deviceOperationMode       = Int(data[1])
        let modeThermostatState       = Int(data[2])
        let modeManualState           = Int(data[3])
        let runState                  = Int(data[4])  // newly included
        let fuelLevel                 = Int(data[5])
        let currentLevel              = Int(data[6])
        let expectedLevel             = Int(data[7])

        // Extract floats at offsets 8..<12 and 12..<16
        let currentTemperature  = data.subdata(in: 8..<12)
                                    .toFloat32(byteOrder: .LittleEndian)
        let expectedTemperature = data.subdata(in: 12..<16)
                                    .toFloat32(byteOrder: .LittleEndian)

        // Build your model, now passing runState along
        let basicInfo = BasicInfo(
            isTempSensorAttached: temperatureSensorAttached,
            deviceOperationMode:   deviceOperationMode,
            modeThermostatState:   modeThermostatState,
            modeManualState:       modeManualState,
            runState:              runState,
            fuelLevel:             fuelLevel,
            currentLevel:          currentLevel,
            expectedLevel:         expectedLevel,
            currentTemp:           currentTemperature,
            expectedTemp:          expectedTemperature
        )

        handler.getCallBackToCentral()?
               .onBasicInfoRsp(basicInfo: basicInfo, handler: handler)
    }
}
