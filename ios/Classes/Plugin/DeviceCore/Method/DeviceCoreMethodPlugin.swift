//
//  DeviceCoreMethodPlugin.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation
import Darwin

class DeviceCoreMethodPlugin: NSObject {
    
    private let eventHandler = DeviceCoreEventHandler()
    
    static func register(with messenger: FlutterBinaryMessenger){
        let instance = DeviceCoreMethodPlugin()
        
        let channel = FlutterMethodChannel(name: ChannelNames.DEVICE_CORE_METHOD_CHANNEL, binaryMessenger: messenger)
        channel.setMethodCallHandler(instance.handle)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let params = call.arguments as? Array<Any>
        NSLog("[DeviceCoreMethodPlugin] handle: \(call.method)")
//        FileLogger.log("[CorePlugin] - handle: \(call.method)")
        switch call.method {
        case DeviceCoreMethod.hasBlePermission.rawValue:
            DeviceCoreMethodHelper.shared.hasBlePermission(params: params, result: result)
            break
        case DeviceCoreMethod.isBleEnabled.rawValue:
            DeviceCoreMethodHelper.shared.isBleEnabled(params: params, result: result)
            break
        case DeviceCoreMethod.startScan.rawValue:
            DeviceCoreMethodHelper.shared.startScan(params: params, result: result)
            break
        case DeviceCoreMethod.stopScan.rawValue:
            DeviceCoreMethodHelper.shared.stopScan(params: params, result: result)
            break
        case DeviceCoreMethod.connect.rawValue:
            DeviceCoreMethodHelper.shared.connect(params: params, result: result)
            break
        case DeviceCoreMethod.disconnect.rawValue:
            DeviceCoreMethodHelper.shared.disconnect(params: params, result: result)
            break
        case DeviceCoreMethod.reconnect.rawValue:
            DeviceCoreMethodHelper.shared.reconnect(params: params, result: result)
            break
        case DeviceCoreMethod.reconnectDevices.rawValue:
//            DeviceCoreMethodHelper.shared.isBleEnabled(params: params, result: result)
            break
        case DeviceCoreMethod.getDeviceName.rawValue:
            DeviceCoreMethodHelper.shared.getDeviceName(params: params, result: result)
            break
        case DeviceCoreMethod.setDeviceName.rawValue:
            DeviceCoreMethodHelper.shared.setDeviceName(params: params, result: result)
            break
        case DeviceCoreMethod.getDeviceInfo.rawValue:
            DeviceCoreMethodHelper.shared.getDeviceInfo(params: params, result: result)
            break
        case DeviceCoreMethod.setThermostatControlMode.rawValue:
            DeviceCoreMethodHelper.shared.setThermostatControlMode(params: params, result: result)
            break
        case DeviceCoreMethod.setManualControlMode.rawValue:
            DeviceCoreMethodHelper.shared.setManualControlMode(params: params, result: result)
            break
        case DeviceCoreMethod.getBasicInfo.rawValue:
            DeviceCoreMethodHelper.shared.getBasicInfo(params: params, result: result)
            break
        case DeviceCoreMethod.getHotBoxData.rawValue:
            DeviceCoreMethodHelper.shared.getHotBoxData(params: params, result: result)
            break
        case DeviceCoreMethod.setTimeStamp.rawValue:
            DeviceCoreMethodHelper.shared.setTimeStamp(params: params, result: result)
            break
        case DeviceCoreMethod.getTimeStamp.rawValue:
            DeviceCoreMethodHelper.shared.getTimeStamp(params: params, result: result)
            break
        case DeviceCoreMethod.getSchedule.rawValue:
            DeviceCoreMethodHelper.shared.getSchedule(params: params, result: result)
            break
        case DeviceCoreMethod.setSchedule.rawValue:
            DeviceCoreMethodHelper.shared.setSchedule(params: params, result: result)
            break
        case DeviceCoreMethod.resetFuelLevel.rawValue:
            DeviceCoreMethodHelper.shared.resetFuelLevel(params: params, result: result)
            break
        case DeviceCoreMethod.setFuelCapacity.rawValue:
            DeviceCoreMethodHelper.shared.setFuelCapacity(params: params, result: result)
            break
        case DeviceCoreMethod.setFuelPump.rawValue:
            DeviceCoreMethodHelper.shared.setFuelPump(params: params, result: result)
            break
        case DeviceCoreMethod.setSeaLevel.rawValue:
            DeviceCoreMethodHelper.shared.setSeaLevel(params: params, result: result)
            break
        case DeviceCoreMethod.setTempOffset.rawValue:
            DeviceCoreMethodHelper.shared.setTempOffset(params: params, result: result)
            break
            
        case DeviceCoreMethod.getHeaterTuning.rawValue:
            DeviceCoreMethodHelper.shared.getHeaterTuning(params: params, result: result)
            break
            
        case DeviceCoreMethod.getHeaterTuning.rawValue:
            DeviceCoreMethodHelper.shared.setHeaterTuning(params: params, result: result)
            break
            
        default:
            result(nil)
        }
    }
    
}
