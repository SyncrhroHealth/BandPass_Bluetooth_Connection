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
    }
    
    func onDisConnected(handler: DeviceHandler) {
        NSLog("[CoreHandler - onDisConnected]")
        callBackToPlugin?.onDisConnected(handler: handler)
    }
    
    func onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler) {
        NSLog("[CoreHandler - onDeviceInfoRsp] deviceInfo: \(deviceInfo)")
        callBackToPlugin?.onDeviceInfoRsp(deviceInfo: deviceInfo, handler: handler)
    }

    func onImuDataRsp(imuData: IMUData, handler: DeviceHandler) {
        NSLog("[CoreHandler - onImuDataRsp] imuData: \(imuData)")
        callBackToPlugin?.onImuDataRsp(imuRsp: imuData, handler: handler)
    }

    func onBatteryLevelRsp(batteryLevel: UInt16, handler: DeviceHandler) {
        NSLog("[CoreHandler - onBatteryLevelRsp] batteryLevel: \(batteryLevel)")
        callBackToPlugin?.onBatteryLevelRsp(batteryLevel: batteryLevel, handler: handler)
    }

}

