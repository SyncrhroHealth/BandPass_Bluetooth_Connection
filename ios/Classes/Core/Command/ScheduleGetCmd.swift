//
//  ScheduleGetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

struct ScheduleGetCmd {
    static func send(handler: DeviceHandler) {
        let builder = CommandBuilder.build(commandCode: .packetCmdScheduleGet)
        handler.write(data: builder)
    }
}
