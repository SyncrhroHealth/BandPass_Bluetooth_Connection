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
    case getDeviceName = "getDeviceName"
    case setDeviceName = "setDeviceName"
    case getDeviceInfo = "getDeviceInfo"
    case setThermostatControlMode = "setThermostatControlMode"
    case setManualControlMode = "setManualControlMode"
    case getBasicInfo = "getBasicInfo"
    case getHotBoxData = "getHotBoxData"
    case setTimeStamp = "setTimeStamp"
    case getTimeStamp = "getTimeStamp"
    case getSchedule = "getSchedule"
    case setSchedule = "setSchedule"
    case resetFuelLevel = "resetFuelLevel"
    case setFuelCapacity = "setFuelCapacity"
    case setFuelPump = "setFuelPump"
    case setSeaLevel = "setSeaLevel"
    case setTempOffset = "setTempOffset"
    case setHeaterTuning = "setHeaterTuning"
    case getHeaterTuning = "getHeaterTuning"
}
