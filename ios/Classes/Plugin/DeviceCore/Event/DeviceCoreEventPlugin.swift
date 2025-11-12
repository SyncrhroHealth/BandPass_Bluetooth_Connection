//
//  DeviceCoreEventPlugin.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation
import CoreBluetooth
import Flutter

class DeviceCoreEventPlugin: NSObject {
    private let eventHandler = DeviceCoreEventHandler()

    
    static func register(with messenger: FlutterBinaryMessenger){
        let instance = DeviceCoreEventPlugin()
        
        let event = FlutterEventChannel(name: ChannelNames.DEVICE_CORE_EVENT_CHANNEL, binaryMessenger: messenger)
        event.setStreamHandler(instance.eventHandler)
        
        CoreHandler.shared.setListener(callBack: instance)
    }
}

extension DeviceCoreEventPlugin: CoreHandlerToPluginCallBack {
    
    func onFoundDevice(device: CBPeripheral, rssi: NSNumber) {
        let map = [
            "address": device.identifier.uuidString,
            "name": device.name ?? "",
            "rssi": rssi,
        ] as [String: Any]
        eventHandler.send(event: DeviceCoreEvent.onDeviceFound.rawValue, body: map)
    }
    
    func onConnected(handler: DeviceHandler) {
        let device = DeviceCoreMethodHelper.shared.createDeviceMap(handler: handler)
        eventHandler.send(event: DeviceCoreEvent.onDeviceConnected.rawValue, body: device)
    }
    
    func onDisConnected(handler: DeviceHandler) {
        let device = DeviceCoreMethodHelper.shared.createDeviceMap(handler: handler)
        eventHandler.send(event: DeviceCoreEvent.onDeviceDisconnected.rawValue, body: device)
    }
    
    // Data response
    
    func onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler) {
        let map: [String: Any] = [
            "address": handler.getDevice()?.getAddress() ?? "",
            "fwVersion": deviceInfo.fwVersion,
            "hwVersion": deviceInfo.hwVersion,
            "macAddress": deviceInfo.macAddress,
            "deviceName": deviceInfo.deviceName
        ]
        eventHandler.send(event: DeviceCoreEvent.onDeviceInfoRsp.rawValue, body: map)
    }

    func onImuDataRsp(imuRsp: IMUData, handler: DeviceHandler) {
        let map: [String: Any] = [
            "address": handler.getDevice()?.getAddress() ?? "",
            "date": imuRsp.date,
            "timeMs": imuRsp.timeMs,
            "count": imuRsp.count,
            "accelX": imuRsp.accelX,
            "accelY": imuRsp.accelY,
            "accelZ": imuRsp.accelZ,
            "gyroX": imuRsp.gyroX,
            "gyroY": imuRsp.gyroY,
            "gyroZ": imuRsp.gyroZ,
            "adcRaw": imuRsp.adcRaw
        ]
        eventHandler.send(event: DeviceCoreEvent.onImuDataRsp.rawValue, body: map)
    }

    func onBatteryLevelRsp(batteryLevel: UInt16, handler: DeviceHandler) {
        let map: [String: Any] = [
            "address": handler.getDevice()?.getAddress() ?? "",
            "level": Int(batteryLevel)
        ]
        eventHandler.send(event: DeviceCoreEvent.onBatteryLevelRsp.rawValue, body: map)
    }

}

