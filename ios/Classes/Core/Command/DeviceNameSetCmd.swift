//
//  DeviceInfoNameSetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `char[20] name`
struct DeviceNameSetCmd {
    static func send(name: String, handler: DeviceHandler) {
        let nameData = nameTo20Bytes(name: name)
        
        // Convert [UInt8] to Data using the correct function from Data+ext.swift
        let nameDataAsData = Data.byteArrayToData(nameData)
        
        let packet = CommandBuilder.build(commandCode: .packetCmdDeviceNameSet, data: nameDataAsData)
        handler.write(data: packet)
    }

    private static func nameTo20Bytes(name: String) -> [UInt8] {
        let raw = Array(name.prefix(20).utf8)  // Convert string to UTF-8 byte array (ASCII compatible)
        
        if raw.count == 20 {
            return raw
        } else {
            return raw + Array(repeating: 0, count: 20 - raw.count) // Pad with zeros
        }
    }
}
