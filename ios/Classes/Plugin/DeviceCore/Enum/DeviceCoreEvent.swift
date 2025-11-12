//
//  DeviceCoreEvent.swift
//  Runner
//
//  Created by MAC on 12/3/25.
//

import Foundation

/// Make sure the event value matches the `DeviceCoreEvent` on the Flutter side
enum DeviceCoreEvent: String {
    // Connection
    case onDeviceFound = "onDeviceFound"
    case onDeviceConnected = "onDeviceConnected"
    case onDeviceDisconnected = "onDeviceDisconnected"

    // Data response
    case onDeviceInfoRsp = "onDeviceInfoRsp"
    case onImuDataRsp = "onImuDataRsp"
    case onBatteryLevelRsp = "onBatteryLevelRsp"
}
