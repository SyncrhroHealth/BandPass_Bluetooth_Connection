//
//  HotBoxDataRspHandler.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `uint8_t fuel_level`
/// - `uint16_t fan_speed`
/// - `uint16_t pump_rate`
/// - `uint16_t glow_plug_power`
/// - `uint16_t sea_level`
/// - `float supply_voltage`
/// - `float heater_temperature`
/// - `float fuel_capacity`
/// - `float fuel_pump`
/// - `float temperature_offset`
/// - `float current_temperature`
/// - `uint8_t current_level`
/// - `uint8_t temperature_sensor_is_attached`
/// - `uint8_t device_operation_mode`
struct HotBoxDataRspHandler {
    static func handle(data: Data, handler: DeviceHandler) {
        print("HotBoxDataRspHandler - data len: \(data.count), data: \(data.toHexString())")

        guard data.count >= 41 else {
            print("HotBoxDataRspHandler - Error: Not enough data received")
            return
        }

        do {
            // 1) fuel_level (1 byte, index 0)
            let fuelLevel = Int(data[0])

            // 2) fan_speed (2 bytes, indices 1..2)
            let fanSpeed = data.subdata(in: 1..<3).toUInt16(byteOrder: .LittleEndian)

            // 3) pump_rate (2 bytes, indices 3..4)
            let pumpRate = data.subdata(in: 3..<5).toUInt16(byteOrder: .LittleEndian)

            // 4) glow_plug_power (2 bytes, indices 5..6)
            let glowPlugPower = data.subdata(in: 5..<7).toUInt16(byteOrder: .LittleEndian)

            // 5) sea_level (2 bytes, indices 7..8)
            let seaLevel = data.subdata(in: 7..<9).toUInt16(byteOrder: .LittleEndian)

            // 6) supply_voltage (float, 4 bytes, indices 9..12)
            let supplyVoltage = data.subdata(in: 9..<13).toFloat32(byteOrder: .LittleEndian) ?? 0.0

            // 7) heater_temperature (float, 4 bytes, indices 13..16)
            let heaterTemperature = data.subdata(in: 13..<17).toFloat32(byteOrder: .LittleEndian) ?? 0.0

            // 8) fuel_capacity (float, 4 bytes, indices 17..20)
            let fuelCapacity = data.subdata(in: 17..<21).toFloat32(byteOrder: .LittleEndian) ?? 0.0

            // 9) fuel_pump (float, 4 bytes, indices 21..24)
            let fuelPump = data.subdata(in: 21..<25).toFloat32(byteOrder: .LittleEndian) ?? 0.0

            // 10) temperature_offset (float, 4 bytes, indices 25..28)
            let temperatureOffset = data.subdata(in: 25..<29).toFloat32(byteOrder: .LittleEndian) ?? 0.0

            // 11) current_temperature (float, 4 bytes, indices 29..32)
            let currentTemperature = data.subdata(in: 29..<33).toFloat32(byteOrder: .LittleEndian) ?? 0.0

            // 12) current_level (1 byte, index 33)
            let currentLevel = Int(data[33])

            // 13) temperature_sensor_is_attached (1 byte, index 34)
            let temperatureSensorIsAttached = Int(data[34])

            // 14) device_operation_mode (1 byte, index 35)
            let deviceOperationMode = Int(data[35])

            // Build HotBoxData object
            let hotBoxData = HotBoxData(
                fuelLevel: fuelLevel,
                fanSpeed: Int(fanSpeed),
                pumpRate: Int(pumpRate),
                glowPlugPower: Int(glowPlugPower),
                seaLevel: Int(seaLevel),
                supplyVoltage: supplyVoltage,
                heaterTemp: heaterTemperature,
                fuelCapacity: fuelCapacity,
                fuelPump: fuelPump,
                tempOffset: temperatureOffset,
                currentTemperature: currentTemperature,
                currentLevel: currentLevel,
                temperatureSensorIsAttached: temperatureSensorIsAttached,
                deviceOperationMode: deviceOperationMode
            )

            print("HotBoxDataRspHandler - handle: Success")
            handler.getCallBackToCentral()?.onHotBoxDataRsp(hotBoxData: hotBoxData, handler: handler)
        } catch {
            print("HotBoxDataRspHandler - Error parsing data: \(error)")
        }
    }
}
