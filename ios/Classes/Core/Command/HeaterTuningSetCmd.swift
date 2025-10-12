//
//  HeaterTuningSetCmd.swift
//  Runner
//
//  Created by MAC on 20/4/25.
//

import Foundation

/// Data format:
/// - `uint16_t fan_max`        (2 bytes, little-endian)
/// - `uint16_t fan_min`        (2 bytes, little-endian)
/// - `float pump_rate_max`     (4 bytes, little-endian)
/// - `float pump_rate_min`     (4 bytes, little-endian)

struct HeaterTuningSetCmd {
    static func send(fanMax: UInt16, fanMin: UInt16, pumpRateMax: Float, pumpRateMin: Float, handler: DeviceHandler) {
        var data = Data()
        data.append(fanMax.toData())
        data.append(fanMin.toData())
        data.append(seaLevel.toData())
        data.append(pumpRateMax.toData())
        data.append(pumpRateMin.toData())
        return data
    }
}
