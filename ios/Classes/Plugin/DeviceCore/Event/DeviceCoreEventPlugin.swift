//
//  DeviceCoreEventPlugin.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation
import CoreBluetooth

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
    
    func onDeviceNameRsp(deviceName: String, handler: DeviceHandler) {
        let device = DeviceCoreMethodHelper.shared.createDeviceMap(handler: handler)
        let map : [String: Any] = [
            "address": handler.getDevice()?.getAddress(),
            "name": deviceName,
        ]
        eventHandler.send(event: DeviceCoreEvent.onDeviceNameRsp.rawValue, body: map)
    }
    
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

    func onBasicInfoRsp(basicInfo: BasicInfo, handler: DeviceHandler) {
        let map: [String: Any] = [
            "address": handler.getDevice()?.getAddress() ?? "",
            "isTempSensorAttached": basicInfo.isTempSensorAttached,
            "deviceOperationMode": basicInfo.deviceOperationMode,
            "modeThermostatState": basicInfo.modeThermostatState,
            "modeManualState": basicInfo.modeManualState,
            "runState": basicInfo.runState,
            "fuelLevel": basicInfo.fuelLevel,
            "currentLevel": basicInfo.currentLevel,
            "expectedLevel": basicInfo.expectedLevel,
            "currentTemp": basicInfo.currentTemp,
            "expectedTemp": basicInfo.expectedTemp
        ]
        eventHandler.send(event: DeviceCoreEvent.onBasicInfoRsp.rawValue, body: map)
    }

    func onHotBoxDataRsp(hotBoxData: HotBoxData, handler: DeviceHandler) {
        let map: [String: Any] = [
            "address": handler.getDevice()?.getAddress() ?? "",
            "fuelLevel": hotBoxData.fuelLevel,
            "fanSpeed": hotBoxData.fanSpeed,
            "pumpRate": hotBoxData.pumpRate,
            "glowPlugPower": hotBoxData.glowPlugPower,
            "seaLevel": hotBoxData.seaLevel,
            "supplyVoltage": hotBoxData.supplyVoltage,
            "heaterTemp": hotBoxData.heaterTemp,
            "fuelCapacity": hotBoxData.fuelCapacity,
            "fuelPump": hotBoxData.fuelPump,
            "tempOffset": hotBoxData.tempOffset,
            "currentTemperature": hotBoxData.currentTemperature,
            "currentLevel": hotBoxData.currentLevel,
            "temperatureSensorIsAttached": hotBoxData.temperatureSensorIsAttached,
            "deviceOperationMode": hotBoxData.deviceOperationMode
        ]
        eventHandler.send(event: DeviceCoreEvent.onHotBoxDataRsp.rawValue, body: map)
    }

    func onTimeStampRsp(timeStamp: TimeStamp, handler: DeviceHandler) {
        let map: [String: Any] = [
            "address": handler.getDevice()?.getAddress() ?? "",
            "epoch": timeStamp.epoch
        ]
        eventHandler.send(event: DeviceCoreEvent.onTimeStampRsp.rawValue, body: map)
    }

    func onScheduleRsp(schedule: Schedule, handler: DeviceHandler) {
        let map: [String: Any] = [
            "address": handler.getDevice()?.getAddress() ?? "",
            "enableSchedule": schedule.enableSchedule,
            "turnOnHour": schedule.turnOn.hour,
            "turnOnMinute": schedule.turnOn.minute,
            "turnOnAmOrPm": schedule.turnOn.amOrPm,
            "turnOffHour": schedule.turnOff.hour,
            "turnOffMinute": schedule.turnOff.minute,
            "turnOffAmOrPm": schedule.turnOff.amOrPm
        ]
        eventHandler.send(event: DeviceCoreEvent.onScheduleRsp.rawValue, body: map)
    }
    
    func onHeaterTuningRsp(heaterTuning: HeaterTuning, handler: DeviceHandler) {
        let map: [String: Any] = [
            "address": handler.getDevice()?.getAddress() ?? "",
            "fanMax": heaterTuning.fanMax,
            "fanMin": heaterTuning.fanMin,
            "pumpRateMax": heaterTuning.pumpRateMax,
            "pumpRateMin": heaterTuning.pumpRateMin,
        ]
        eventHandler.send(event: DeviceCoreEvent.onHeaterTuningRsp.rawValue, body: map)
    }

}

