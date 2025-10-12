//
//  TempOffsetSetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `float temperature_offset` (4 bytes, little-endian)
struct TempOffsetSetCmd {
    static func send(tempOffset: Float, handler: DeviceHandler) {
        let tempOffsetData = Data.Float32ToData(Float32(tempOffset), byteOder: .LittleEndian)
        
        var data = Data()
        data.append(tempOffsetData)
        
        let packet = CommandBuilder.build(commandCode: .packetCmdTemperatureOffsetSet, data: data)
        handler.write(data: packet)
    }
}
