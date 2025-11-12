//
//  ReceiveDataHandler.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

struct ReceiveDataHandler {
    static func handle(packet: Packet, handler: DeviceHandler) {
        print("ReceiveDataHandler - handle: \(packet.header.commandCode)")

        guard let commandCode = packet.header.commandCode else {
            print("ReceiveDataHandler - Unknown command code: nil")
            return
        }

        switch commandCode {
        
        /// Responses
        case .packetCmdDeviceInfoResp:
            DeviceInfoRspHandler.handle(data: packet.data, handler: handler)

        case .packetCmdImuDataRsp:
            ImuDataRspHandler.handle(data: packet.data, handler: handler)

        default:
            print("ReceiveDataHandler - Unknown command code: \(commandCode)")
        }
    }
}
