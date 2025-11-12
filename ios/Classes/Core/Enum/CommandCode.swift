//
//  CommandCode.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation

enum CommandCode: UInt8, CaseIterable {
    case packetCmdDeviceInfoGet    = 1
    case packetCmdDeviceInfoResp   = 2
    case packetCmdImuDataRsp        = 3

    var value: UInt8 {
        return self.rawValue
    }

    static func fromValue(_ value: UInt8) -> CommandCode? {
        return CommandCode(rawValue: value)
    }
}
