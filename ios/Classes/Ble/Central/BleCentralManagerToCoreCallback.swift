//
//  BleCentralManagerToCoreCallback.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import CoreBluetooth

protocol BleCentralManagerToCoreCallback {
    //CONNECTION
    func onBleState(enable: Bool)
    func onFoundDevice(peripheral: CBPeripheral, rssi: NSNumber)

    /**
     Receive connect event from [DeviceHandler]
     */
    func onConnected(handler: DeviceHandler)
    
    /**
     Receive disconnect event from [DeviceHandler]
     */
    func onDisConnected(handler: DeviceHandler)

    // DATA RESPONSE

    /**
     Receive device name response
     */
    func onDeviceNameRsp(deviceName: String, handler: DeviceHandler)

    /**
     Receive device info response
     */
    func onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler)

    /**
     Receive basic info response
     */
    func onBasicInfoRsp(basicInfo: BasicInfo, handler: DeviceHandler)

    /**
     Receive hot box data response
     */
    func onHotBoxDataRsp(hotBoxData: HotBoxData, handler: DeviceHandler)

    /**
     Receive timestamp response
     */
    func onTimeStampRsp(timeStamp: TimeStamp, handler: DeviceHandler)

    /**
     Receive schedule response
     */
    func onScheduleRsp(schedule: Schedule, handler: DeviceHandler)
    
    /**
     Receive heater tuning response
     */
    func onHeaterTuningRsp(heaterTuning: HeaterTuning, handler: DeviceHandler)
}
