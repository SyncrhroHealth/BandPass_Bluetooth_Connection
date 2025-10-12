//
//  HeaterTuningRspHandler.swift
//  Runner
//
//  Created by MAC on 20/4/25.
//

import Foundation

/// Data payload format (header already stripped):
/// - `uint16_t fan_max`        (2 bytes, little-endian)
/// - `uint16_t fan_min`        (2 bytes, little-endian)
/// - `float    pump_rate_max`  (4 bytes, little-endian)
/// - `float    pump_rate_min`  (4 bytes, little-endian)

struct HeaterTuningRspHandler {
    private static let expectedLength = 12

    static func handle(data: Data, handler: DeviceHandler) {
        guard data.count >= expectedLength else {
            print("⚠️ HeaterTuningRspHandler: payload too short (\(data.count) bytes), expected at least \(expectedLength).")
            return
        }

        // Parse in little‑endian order
        let fanMax       = Int(data.subdata(in: 0..<2).toUInt16(byteOrder: .LittleEndian))
        let fanMin       = Int(data.subdata(in: 2..<4).toUInt16(byteOrder: .LittleEndian))
        let pumpRateMax  = data.subdata(in: 4..<8).toFloat32(byteOrder: .LittleEndian)
        let pumpRateMin  = data.subdata(in: 8..<12).toFloat32(byteOrder: .LittleEndian)

        let tuning = HeaterTuning(
            fanMax:       fanMax,
            fanMin:       fanMin,
            pumpRateMax:  pumpRateMax,
            pumpRateMin:  pumpRateMin
        )

        handler.getCallBackToCentral()?
            .onHeaterTuningRsp(heaterTuning: tuning, handler: handler)
    }
}
