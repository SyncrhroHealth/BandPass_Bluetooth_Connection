//
//  FuelCapacitySetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `float fuel_capacity` (4 bytes, little-endian)
struct FuelCapacitySetCmd {
    static func send(fuelCapacity: Float, handler: DeviceHandler) {
        var data = Data()
        
        // Convert fuelCapacity (Float) to Data (4 bytes, little-endian)
        let fuelCapacityData = Data.Float32ToData(fuelCapacity, byteOder: .LittleEndian)
        data.append(fuelCapacityData)
        
        // Build the packet with CommandBuilder
        let packet = CommandBuilder.build(commandCode: .packetCmdFuelCapacitySet, data: data)
        
        // Send packet
        handler.write(data: packet)
    }
}
