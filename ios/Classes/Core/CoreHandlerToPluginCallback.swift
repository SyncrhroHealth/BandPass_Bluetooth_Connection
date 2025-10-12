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
    func onDeviceNameRsp(deviceName: String, handler: DeviceHandler)
    func onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler)
    func onBasicInfoRsp(basicInfo: BasicInfo, handler: DeviceHandler)
    func onHotBoxDataRsp(hotBoxData: HotBoxData, handler: DeviceHandler)
    func onTimeStampRsp(timeStamp: TimeStamp, handler: DeviceHandler)
    func onScheduleRsp(schedule: Schedule, handler: DeviceHandler)
    func onHeaterTuningRsp(heaterTuning: HeaterTuning, handler: DeviceHandler)
}
