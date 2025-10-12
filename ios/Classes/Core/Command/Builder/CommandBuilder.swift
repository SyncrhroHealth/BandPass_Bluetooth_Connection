//
//  CommandBuilder.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Packet format: Every packet has a header and data part.
///
/// Header:
/// - uint8_t `cmd` (Packet command)
/// - uint8_t `len` (Data length)
/// - uint16_t `msg_index` (Message index)
///
/// Data:
/// - uint8_t `data[256]` (Data (Max size 256 bytes))
struct CommandBuilder {
    
    static func build(commandCode: CommandCode, data: Data? = nil) -> Data { // Added `= nil` as default value
        var packet = Data() // Correctly initializing Data object

        /// Build Header
        packet.append(commandCode.rawValue) // Add Command code
        packet.append(0)                 // Add Data length
        packet.append(0)                 // Add Message index (low byte)
        packet.append(0)                 // Add Message index (high byte)

        /// Build Data (Only append if data exists)
        if let data = data {
            packet.append(data)
        }

        return packet
    }
}
