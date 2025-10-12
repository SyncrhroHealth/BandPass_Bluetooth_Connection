//
//  Untitled.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

struct DeviceInfoGetCmd {
    static func send(handler: DeviceHandler) {
        let builder = CommandBuilder.build(commandCode: .packetCmdDeviceInfoGet)
        handler.write(data: builder)
    }
}
