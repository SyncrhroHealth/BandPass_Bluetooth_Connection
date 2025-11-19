//
//  DeviceCoreMethodPlugin.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation
import Flutter

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
            // TODO: Implement reconnectDevices
            result(true)
            break
            
        case DeviceCoreMethod.getDeviceInfo.rawValue:
            DeviceCoreMethodHelper.shared.getDeviceInfo(params: params, result: result)
            break
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
}
