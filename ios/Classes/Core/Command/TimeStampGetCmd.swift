//
//  TimeStampGetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

struct TimeStampGetCmd {
    static func send(handler: DeviceHandler) {
        let builder = CommandBuilder.build(commandCode: .packetCmdTimestampGet)
        handler.write(data: builder)
    }
}
