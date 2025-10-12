//
//  HeaterTuningGetCmd.swift
//  Runner
//
//  Created by MAC on 20/4/25.
//

import Foundation

struct HeaterTuningGetCmd {
    static func send(handler: DeviceHandler) {
        let builder = CommandBuilder.build(commandCode: .packetCmdHeaterTuningGet)
        handler.write(data: builder)
    }
}
