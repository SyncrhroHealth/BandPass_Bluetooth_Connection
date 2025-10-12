//
//  HotBoxDataGetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

struct HotBoxDataGetCmd {
    static func send(handler: DeviceHandler) {
        let builder = CommandBuilder.build(commandCode: .packetCmdHotboxDataGet)
        handler.write(data: builder)
    }
}
