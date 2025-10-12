//
//  FuelPumpSetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `float fuel_pump` (4 bytes, little-endian)
struct FuelPumpSetCmd {
    static func send(fuelPump: Float, handler: DeviceHandler) {
        var data = Data()
        
        // Convert fuelPump (Float) to Data (4 bytes, little-endian)
        let fuelPumpData = Data.Float32ToData(fuelPump, byteOder: .LittleEndian)
        data.append(fuelPumpData)
        
        // Build the packet with CommandBuilder
        let packet = CommandBuilder.build(commandCode: .packetCmdFuelPumpSet, data: data)
        
        // Send packet
        handler.write(data: packet)
    }
}
