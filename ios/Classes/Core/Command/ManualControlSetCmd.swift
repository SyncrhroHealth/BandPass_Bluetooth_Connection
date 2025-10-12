//
//  ManualControlSetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `uint16_t command` (0: Idle; 1: Running)
/// - `float expected_temperature` (4 bytes, little-endian)
struct ManualControlSetCmd {
    static func send(command: UInt16, expectedTemp: Float, handler: DeviceHandler) {
        var data = Data()
        
        // 1. Convert the command (2 bytes, little-endian)
        let commandData = Data.UInt16ToData(command, byteOder: .LittleEndian)
        data.append(commandData)
        
        // 2. Convert the float to Data (4 bytes, little-endian)
        let expectedTempData = Data.Float32ToData(expectedTemp, byteOder: .LittleEndian)
        data.append(expectedTempData)
        
        // 3. Build the packet with CommandBuilder
        let packet = CommandBuilder.build(commandCode: .packetCmdModeManualControlSet, data: data)
        
        // 4. Send packet
        handler.write(data: packet)
    }
}
