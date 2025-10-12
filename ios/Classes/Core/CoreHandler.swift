//
//  CoreHandler.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import Foundation
import CoreBluetooth


class CoreHandler: BleScannerCallback, BleCentralManagerToCoreCallback {
    
    static let shared = CoreHandler()
    private var central: BleCentralManager?
    private var callBackToPlugin: CoreHandlerToPluginCallBack?
    
    init() {
        central = BleCentralManager.shared
        central?.setScanCallback(callback: self)
        central?.setCoreHandlerCallback(callback: self)
    }
    
    func setListener(callBack: CoreHandlerToPluginCallBack) {
        self.callBackToPlugin = callBack
    }
    
    func isBleEnabled() -> Bool {
        return central?.isEnableBle ?? false
    }

    func hasBlePermission() -> Bool {
        if #available(iOS 13.1, *) { return CBCentralManager.authorization == .allowedAlways }
        if #available(iOS 13.0, *) { return CBCentralManager().authorization == .allowedAlways }
        return true
    }
    
    func startScan() {
        central?.startScan()
    }
    
    func stopScan() {
        central?.stopScan()
    }
    
    func connect(address: String) {
        central?.connect(address: address)
    }
    
    func requestToDisconnect(address: String) {
        central?.requestToDisconnect(address: address)
    }
    
    func getDevice(address: String) -> DeviceHandler? {
        return central?.getDevice(address: address)
    }
    
    //********************* BLUETOOTH STATE CHANGED ************************************************
    
    func onBleState(enable: Bool) {
        if(enable) {
            central?.reconnectAll()
            return
        }
        
        // only change disconnect status
        central?.changeDisconnectStatus()
    }
    
    func onFoundDevice(peripheral: CBPeripheral, rssi: NSNumber) {
        callBackToPlugin?.onFoundDevice(device: peripheral, rssi: rssi)
    }
    
    //********************* DEVICE CONNECTION CHANGED ************************************************
    
    func onConnected(handler: DeviceHandler) {
        NSLog("[CoreHandler - onConnected]")
        callBackToPlugin?.onConnected(handler: handler)
        
        // Set current timestamp and timezone after connection
        let currentTime = UInt64(Date().timeIntervalSince1970 * 1000) // Convert to milliseconds
        let timezoneOffsetSeconds = Int32(TimeZone.current.offsetSeconds())
        TimeStampSetCmd.send(epochTime: currentTime, timezoneOffsetSeconds: timezoneOffsetSeconds, handler: handler)
        NSLog("[CoreHandler - onConnected] Sent timestamp: \(currentTime), timezone offset: \(timezoneOffsetSeconds) seconds")
    }
    
    func onDisConnected(handler: DeviceHandler) {
        NSLog("[CoreHandler - onDisConnected]")
        callBackToPlugin?.onDisConnected(handler: handler)
    }
    
    func onDeviceNameRsp(deviceName: String, handler: DeviceHandler) {
        NSLog("[CoreHandler - onDeviceNameRsp] deviceName: \(deviceName)")
        callBackToPlugin?.onDeviceNameRsp(deviceName: deviceName, handler: handler)
    }

    func onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler) {
        NSLog("[CoreHandler - onDeviceInfoRsp] deviceInfo: \(deviceInfo)")
        callBackToPlugin?.onDeviceInfoRsp(deviceInfo: deviceInfo, handler: handler)
    }

    func onBasicInfoRsp(basicInfo: BasicInfo, handler: DeviceHandler) {
        NSLog("[CoreHandler - onBasicInfoRsp] basicInfo: \(basicInfo)")
        callBackToPlugin?.onBasicInfoRsp(basicInfo: basicInfo, handler: handler)
    }

    func onHotBoxDataRsp(hotBoxData: HotBoxData, handler: DeviceHandler) {
        NSLog("[CoreHandler - onHotBoxDataRsp] hotBoxData: \(hotBoxData)")
        callBackToPlugin?.onHotBoxDataRsp(hotBoxData: hotBoxData, handler: handler)
    }

    func onTimeStampRsp(timeStamp: TimeStamp, handler: DeviceHandler) {
        NSLog("[CoreHandler - onTimeStampRsp] timeStamp: \(timeStamp)")
        callBackToPlugin?.onTimeStampRsp(timeStamp: timeStamp, handler: handler)
    }

    func onScheduleRsp(schedule: Schedule, handler: DeviceHandler) {
        NSLog("[CoreHandler - onScheduleRsp] schedule: \(schedule)")
        callBackToPlugin?.onScheduleRsp(schedule: schedule, handler: handler)
    }
    
    func onHeaterTuningRsp(heaterTuning: HeaterTuning, handler: DeviceHandler) {
        NSLog("[CoreHandler - onHeaterTuningRsp] heaterTuning: \(heaterTuning)")
    }

}

