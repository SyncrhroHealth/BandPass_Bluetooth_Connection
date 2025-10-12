//
//  DeviceNameRspHandler.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `char[20] name`
struct DeviceNameRspHandler {
    static func handle(data: Data, handler: DeviceHandler) {
        do {
            // Ensure we only extract up to 20 bytes
            let deviceNameData = data.prefix(20)

            // Convert data to string and trim trailing null characters
            let deviceName = deviceNameData.toString()?.trimmingCharacters(in: .controlCharacters) ?? ""

            handler.getCallBackToCentral()?.onDeviceNameRsp(deviceName: deviceName, handler: handler)
        } catch {
            print("DeviceNameRspHandler - Error parsing data: \(error)")
        }
    }
}
