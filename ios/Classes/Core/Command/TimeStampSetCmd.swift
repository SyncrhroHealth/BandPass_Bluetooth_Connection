//
//  TimeStampSetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `uint64_t epoch_time` (8 bytes, little-endian)
/// - `int32_t timezone_offset_seconds` (4 bytes, little-endian)
struct TimeStampSetCmd {
    static func send(epochTime: UInt64, timezoneOffsetSeconds: Int32, handler: DeviceHandler) {
        var data = Data()
        
        // 1. Convert epochTime (UInt64) to Data (8 bytes, little-endian)
        let epochTimeData = Data.UInt64ToData(UInt64(epochTime), byteOder: .LittleEndian)
        data.append(epochTimeData)
        
        // 2. Convert timezoneOffsetSeconds (Int32) to Data (4 bytes, little-endian)
        let timezoneData = Data.Int32ToData(timezoneOffsetSeconds, byteOder: .LittleEndian)
        data.append(timezoneData)
        
        // 3. Build the packet with CommandBuilder
        let packet = CommandBuilder.build(commandCode: .packetCmdTimestampSet, data: data)
        
        // 4. Send packet
        handler.write(data: packet)
    }
}
