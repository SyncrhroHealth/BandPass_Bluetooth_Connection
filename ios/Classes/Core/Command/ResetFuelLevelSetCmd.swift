//
//  ResetFuelLevelSetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

struct ResetFuelLevelSetCmd {
    static func send(handler: DeviceHandler) {
        let builder = CommandBuilder.build(commandCode: .packetCmdResetFuelLevelSet)
        handler.write(data: builder)
    }
}
