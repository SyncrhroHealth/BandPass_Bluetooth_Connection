//
//  BasicInfoGetCmd.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

struct BasicInfoGetCmd {
    static func send(handler: DeviceHandler) {
        let builder = CommandBuilder.build(commandCode: .packetCmdBasicInfoGet)
        handler.write(data: builder)
    }
}
