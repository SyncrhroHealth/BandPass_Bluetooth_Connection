//
//  DeviceCoreMethodHelper.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation

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
    }
    
    /** Command */
    
    func getDeviceName(params: [Any]?, result: @escaping FlutterResult) {
        guard let uuid = params?[0] as? String else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: uuid)
        
        if let handler = handler {
            DeviceNameGetCmd.send(handler: handler)
        }
        
        result(true)
    }
    
    func setDeviceName(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 2,
              let address = params[0] as? String,
              let name = params[1] as? String else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: address)
        
        if let handler = handler {
            DeviceNameSetCmd.send(name: name, handler: handler)
        }
        
        result(true)
    }
    
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
    
    func setThermostatControlMode(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 3,
              let address = params[0] as? String,
              let command = params[1] as? UInt16,
              let expectedTempDouble = params[2] as? Double else {
            result(false)
            return
        }
        
        let expectedTemp = Float(expectedTempDouble)
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            ThermostatControlSetCmd.send(command: command, expectedTemp: expectedTemp, handler: handler)
        }
        
        result(true)
    }
    
    func setManualControlMode(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 3,
              let address = params[0] as? String,
              let command = params[1] as? UInt16,
              let expectedTempDouble = params[2] as? Double else {
            result(false)
            return
        }
        
        let expectedTemp = Float(expectedTempDouble)
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            ManualControlSetCmd.send(command: command, expectedTemp: expectedTemp, handler: handler)
        }
        
        result(true)
    }
    
    func getBasicInfo(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              let address = params[0] as? String else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            BasicInfoGetCmd.send(handler: handler)
        }
        
        result(true)
    }
    
    func getHotBoxData(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              let address = params[0] as? String else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            HotBoxDataGetCmd.send(handler: handler)
        }
        result(true)
    }
    
    func setTimeStamp(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 3,
              let address = params[0] as? String,
              let epoch = params[1] as? Int64, epoch >= 0, // Ensure epoch is non-negative
              let timezoneOffsetSeconds = params[2] as? Int32 else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            TimeStampSetCmd.send(epochTime: UInt64(epoch), timezoneOffsetSeconds: timezoneOffsetSeconds, handler: handler)
        }
        result(true)
    }

    func getTimeStamp(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              let address = params[0] as? String else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            TimeStampGetCmd.send(handler: handler)
        }
        result(true)
    }
    
    func getSchedule(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              let address = params[0] as? String else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            ScheduleGetCmd.send(handler: handler)
        }
        result(true)
    }
    
    func setSchedule(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 8,
              let address = params[0] as? String,
              let enableSchedule = params[1] as? Int,
              let turnOnHour = params[2] as? Int,
              let turnOnMinute = params[3] as? Int,
              let turnOnAmPm = params[4] as? Int,
              let turnOffHour = params[5] as? Int,
              let turnOffMinute = params[6] as? Int,
              let turnOffAmPm = params[7] as? Int else {
            result(false)
            return
        }
        
        let schedule = Schedule(
            enableSchedule: enableSchedule,
            turnOn: TimeSchedule(hour: turnOnHour, minute: turnOnMinute, amOrPm: turnOnAmPm),
            turnOff: TimeSchedule(hour: turnOffHour, minute: turnOffMinute, amOrPm: turnOffAmPm)
        )
        
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            ScheduleSetCmd.send(schedule: schedule, handler: handler)
        }
        result(true)
    }
    
    func resetFuelLevel(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              let address = params[0] as? String else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            ResetFuelLevelSetCmd.send(handler: handler)
        }
        result(true)
    }
    
    func setFuelCapacity(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 2,
              let address = params[0] as? String,
              let fuelCapacityDouble = params[1] as? Double else {
            result(false)
            return
        }
        
        let fuelCapacity = Float(fuelCapacityDouble)
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            FuelCapacitySetCmd.send(fuelCapacity: fuelCapacity, handler: handler)
        }
        result(true)
    }
    
    func setFuelPump(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 2,
              let address = params[0] as? String,
              let fuelPumpDouble = params[1] as? Double else {
            result(false)
            return
        }
        
        let fuelPump = Float(fuelPumpDouble)
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            FuelPumpSetCmd.send(fuelPump: fuelPump, handler: handler)
        }
        result(true)
    }
    
    func setSeaLevel(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 2,
              let address = params[0] as? String,
              let seaLevel = params[1] as? Int else {
            result(false)
            return
        }
        
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            SeaLevelSetCmd.send(seaLevel: seaLevel, handler: handler)
        }
        result(true)
    }
    
    func setTempOffset(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 2,
              let address = params[0] as? String,
              let tempOffsetDouble = params[1] as? Double else {
            result(false)
            return
        }
        
        let tempOffset = Float(tempOffsetDouble)
        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            TempOffsetSetCmd.send(tempOffset: tempOffset, handler: handler)
        }
        result(true)
    }
    
    func setHeaterTuning(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 5,
              let address = params[0] as? String,
              let fanMax = params[1] as? Int,
              let fanMin = params[2] as? Int,
              let pumpRateMax = params[3] as? Double,
              let pumpRateMin = params[4] as? Double else {
            result(false)
            return
        }

        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            HeaterTuningSetCmd.send(
                fanMax: UInt16(fanMax),
                fanMin: UInt16(fanMin),
                pumpRateMax: Float(pumpRateMax),
                pumpRateMin: Float(pumpRateMin),
                handler: handler
            )
        }

        result(true)
    }
    
    func getHeaterTuning(params: [Any]?, result: @escaping FlutterResult) {
        guard let params = params,
              params.count >= 1,
              let address = params[0] as? String else {
            result(false)
            return
        }

        let handler = CoreHandler.shared.getDevice(address: address)
        if let handler = handler {
            HeaterTuningGetCmd.send(handler: handler)
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
