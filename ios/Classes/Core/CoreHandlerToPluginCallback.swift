//
//  CoreHandlerToPluginCallback.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import Foundation
import CoreBluetooth

protocol CoreHandlerToPluginCallBack {
    // Connection
    func onFoundDevice(device: CBPeripheral, rssi: NSNumber)
    func onConnected(handler: DeviceHandler)
    func onDisConnected(handler: DeviceHandler)

    // Data response
    func onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler)
    func onImuDataRsp(imuRsp: IMUData, handler: DeviceHandler)
    func onBatteryLevelRsp(batteryLevel: UInt16, handler: DeviceHandler)
}
