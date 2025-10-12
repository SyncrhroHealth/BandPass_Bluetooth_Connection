//
//  DeviceNameGetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

struct DeviceNameGetCmd {
    static func send(handler: DeviceHandler) {
        let builder = CommandBuilder.build(commandCode: .packetCmdDeviceNameGet)
        handler.write(data: builder)
    }
}
