//
//  TimeStampRspHandler.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `uint64_t epoch_time` (8 bytes, little-endian)
struct TimeStampRspHandler {
    static func handle(data: Data, handler: DeviceHandler) {
        guard data.count >= 8 else {
            print("TimeStampRspHandler - Error: Not enough data received")
            return
        }

        do {
            // Extract the epoch_time from the data (uint64_t = 8 bytes)
            let epochTime = data.subdata(in: 0..<8).toUInt64(byteOrder: .LittleEndian)

            let timeStamp = TimeStamp(epoch: Int64(epochTime))

            handler.getCallBackToCentral()?.onTimeStampRsp(timeStamp: timeStamp, handler: handler)
        } catch {
            print("TimeStampRspHandler - Error parsing data: \(error)")
        }
    }
}
