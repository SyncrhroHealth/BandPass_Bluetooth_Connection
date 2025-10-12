//
//  TempSenseCoreHelper.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation

class DeviceCoreEventHelper {
    static let shared = DeviceCoreEventHelper()
    
    
    func createDeviceMap(handler: DeviceHandler) -> [String: Any] {
        return [
            "name": handler.getDevice()?.getName() ?? "",
            "address": handler.getDevice()?.getAddress() ?? "",
            "isCharging": handler.getDevice()?.isCharging ?? "",
            "batteryLevel": handler.getDevice()?.batteryLevel ?? "",
            "hwVersion": handler.getDevice()?.hwVersion ?? "",
            "fwVersion": handler.getDevice()?.fwVersion ?? "",
            "model": handler.getDevice()?.model ?? "",
            "serialNumber": handler.getDevice()?.serialNumber ?? ""
        ]
    }
    
    
//    func getDevice(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String else {
//            result(false)
//            return
//        }
//        
//        let handler = CoreHandler.shared.getDevice(address: uuid)
//        
//        if (handler != nil) {
//            result(createDeviceMap(handler: handler!))
//            return
//        }
//        
//        return result(nil)
//    }
//    
//    func hasBlePermission(params: Array<Any>?, result: @escaping FlutterResult) {
//        let hasPermission = CoreHandler.shared.hasBlePermission()
//        result(hasPermission)
//    }
//    
//    func isEnableBle(params: Array<Any>?, result: @escaping FlutterResult) {
//        let enable = CoreHandler.shared.isBleEnabled()
//        result(enable)
//    }
//    
//    func startScan(params: Array<Any>?, result: @escaping FlutterResult) {
//        FileLogger.log("[DeviceCoreEventHelper] - startScan")
//        CoreHandler.shared.startScan()
//        result(true)
//    }
//    
//    func stopScan(params: Array<Any>?, result: @escaping FlutterResult) {
//        FileLogger.log("[DeviceCoreEventHelper] - stopScan")
//        CoreHandler.shared.stopScan()
//    }
//    
//    func connect(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String else {
//            result(false)
//            return
//        }
//        
//        FileLogger.log("[DeviceCoreEventHelper] - connect: \(uuid)")
//        
//        print("connect: uuid: \(uuid)")
//        CoreHandler.shared.connect(address: uuid)
//        result(true)
//    }
//    
//    func requestToDisconnect(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String else {
//            result(false)
//            return
//        }
//        
//        CoreHandler.shared.requestToDisconnect(address: uuid)
//        result(true)
//    }
//    
//    
//    func setThermThreshold(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String,
//              let enable = params?[1] as? Bool,
//        let max = params?[2] as? Double,
//            let min = params?[3] as? Double else {
//                result(false)
//                return
//            }
//        
//        let handler = CoreHandler.shared.getDevice(address: uuid)
//        FileLogger.log("[DeviceCoreEventHelper] - setThermThreshold: \(uuid)")
//        if (handler != nil) {
//            SetThermThresholdCmd.send(enable: enable, max: max, min: min, handler: handler!)
//            result(true)
//            return
//        }
//        
//        result(false)
//    }
//    
//    func setThermEpochTime(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String else {
//            result(false)
//            return
//        }
//        
//        FileLogger.log("[DeviceCoreEventHelper] - setThermEpochTime: \(uuid)")
//        let handler = CoreHandler.shared.getDevice(address: uuid)
//        
//        if (handler != nil) {
//            SetEpochTimeCmd.send(handler: handler!)
//            result(true)
//            return
//        }
//        
//        result(false)
//    }
//    
//    func setMeasurementInterval(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String,
//              let secs = params?[1] as? Int else {
//            result(false)
//            return
//        }
//        FileLogger.log("[DeviceCoreEventHelper] - setMeasurementInterval: \(uuid)")
//        let handler = CoreHandler.shared.getDevice(address: uuid)
//        
//        if (handler != nil) {
//            SetMeasureIntervalCmd.send(secs: secs, handler: handler!)
//            result(true)
//            return
//        }
//        
//        result(false)
//    }
//    
//    
//    func getBatteryLevel(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String else {
//            result(false)
//            return
//        }
//        
//        let handler = CoreHandler.shared.getDevice(address: uuid)
//        FileLogger.log("[DeviceCoreEventHelper] - getBatteryLevel: \(uuid)")
//        if (handler != nil) {
//            GetBatteryLevelCmd.send(handler: handler!)
//            result(true)
//            return
//        }
//        
//        result(false)
//    }
//    
//    func getThermLog(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String else {
//            result(false)
//            return
//        }
//        
//        let handler = CoreHandler.shared.getDevice(address: uuid)
//        FileLogger.log("[DeviceCoreEventHelper] - getThermLog: \(uuid)")
//        
//        if (handler != nil) {
//            GetEpochTimeCmd.send(handler: handler!)
//            GetThermLogCmd.send(handler: handler!)
//            result(true)
//            return
//        }
//        
//        result(false)
//    }
//    
//    func getCurrentTemp(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String else {
//            result(false)
//            return
//        }
//        
//        let handler = CoreHandler.shared.getDevice(address: uuid)
//        
//        if (handler != nil) {
//            GetCurrentTempCmd.send(handler: handler!)
//            result(true)
//            return
//        }
//        
//        result(false)
//    }
//    
//    func getEpochTime(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let uuid = params?[0] as? String else {
//            result(false)
//            return
//        }
//        
//        let handler = CoreHandler.shared.getDevice(address: uuid)
//        
//        if (handler != nil) {
//            GetEpochTimeCmd.send(handler: handler!)
//            result(true)
//            return
//        }
//        
//        result(false)
//    }
//    
//
//    
//    func createTempMap(temp: TempData) -> [String: Any] {
//        return [
//            "time": temp.time,
//            "value": temp.value,
//        ]
//    }
//    
//    func createTempListMap(temp: [TempData]) -> [[String: Any]] {
//        return temp.map{createTempMap(temp: $0)}
//    }
//    
//    func requestToReconnect(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let listAddress = params?[0] as? [String] else {
//            result(false)
//            return
//        }
//        
//        BleCentralManager.shared.requestToReconnect(listAddress: listAddress)
//    }
//    
//    func writeLog(params: Array<Any>?, result: @escaping FlutterResult) {
//        guard let text = params?[0] as? String else {
//            result(false)
//            return
//        }
//        FileLogger.log("\(text)")
//        result(true)
//    }
}
