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
        case .packetCmdDeviceNameResp:
            DeviceNameRspHandler.handle(data: packet.data, handler: handler)

        case .packetCmdDeviceInfoResp:
            DeviceInfoRspHandler.handle(data: packet.data, handler: handler)

        case .packetCmdBasicInfoResp:
            BasicInfoRspHandler.handle(data: packet.data, handler: handler)

        case .packetCmdHotboxDataResp:
            HotBoxDataRspHandler.handle(data: packet.data, handler: handler)

        case .packetCmdTimestampResp:
            TimeStampRspHandler.handle(data: packet.data, handler: handler)

        case .packetCmdScheduleResp:
            ScheduleRspHandler.handle(data: packet.data, handler: handler)
            
        case .packetCmdHeaterTuningResp:
            HeaterTuningRspHandler.handle(data: packet.data, handler: handler)

        default:
            print("ReceiveDataHandler - Unknown command code: \(commandCode)")
        }
    }
}
