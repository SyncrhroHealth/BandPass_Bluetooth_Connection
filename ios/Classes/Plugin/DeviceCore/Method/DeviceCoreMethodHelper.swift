//
//  DeviceCoreMethodHelper.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation
import Flutter

class DeviceCoreMethodHelper {
    static let shared = DeviceCoreMethodHelper()
    
    /** Connection */
    
    func hasBlePermission(params: Array<Any>?, result: @escaping FlutterResult) {
        let hasPermission = CoreHandler.shared.hasBlePermission()
        result(hasPermission)
    }
    
    func isBleEnabled(params: Array<Any>?, result: @escaping FlutterResult) {
        let enable = CoreHandler.shared.isBleEnabled()
        result(enable)
    }
    
    func startScan(params: Array<Any>?, result: @escaping FlutterResult) {
        CoreHandler.shared.startScan()
        result(true)
    }
    
    func stopScan(params: Array<Any>?, result: @escaping FlutterResult) {
        CoreHandler.shared.stopScan()
        result(true)
    }
    
    func connect(params: Array<Any>?, result: @escaping FlutterResult) {
        guard let uuid = params?[0] as? String else {
            result(false)
            return
        }
        
        print("connect: uuid: \(uuid)")
        CoreHandler.shared.connect(address: uuid)
        result(true)
    }
    
    func disconnect(params: Array<Any>?, result: @escaping FlutterResult) {
        guard let uuid = params?[0] as? String else {
            result(false)
            return
        }
        
        CoreHandler.shared.requestToDisconnect(address: uuid)
        result(true)
    }
    
    // TODO: This function is connect a list of devices
    func reconnect(params: Array<Any>?, result: @escaping FlutterResult) {
        guard let listAddress = params?[0] as? [String] else {
            result(false)
            return
        }
        
        BleCentralManager.shared.requestToReconnect(listAddress: listAddress)
        result(true)
    }
    
    /** Command */
    
    func getDeviceInfo(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              let address = params[0] as? String else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            DeviceInfoGetCmd.send(handler: handler)
        }
        
        result(true)
    }
    
    func createDeviceMap(handler: DeviceHandler) -> [String: Any] {
        return [
            "name": handler.getDevice()?.getName(),
            "address": handler.getDevice()?.getAddress()
            // Uncomment and add more fields if needed:
            // "isCharging": handler.getDevice().isCharging,
            // "batteryLevel": handler.getDevice().batteryLevel,
            // "hwVersion": handler.getDevice().hwVersion,
            // "fwVersion": handler.getDevice().fwVersion,
            // "model": handler.getDevice().model,
            // "serialNumber": handler.getDevice().serialNumber
        ]
    }
}
