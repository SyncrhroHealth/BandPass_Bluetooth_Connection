//
//  Untitled.swift
//  Runner
//
//  Created by MAC on 12/3/25.
//

import Foundation

/// Make sure the method value matches the `DeviceCoreMethod` on the Flutter side
enum DeviceCoreMethod: String {
    // Permissions
    case isBleEnabled = "isBleEnabled"
    case hasBlePermission = "hasBlePermission"

    // Scanning
    case startScan = "startScan"
    case stopScan = "stopScan"

    // Connection
    case connect = "connect"
    case disconnect = "disconnect"
    case reconnect = "reconnect"
    case reconnectDevices = "reconnectDevices"

    // Device commands
    case getDeviceInfo = "getDeviceInfo"
}
