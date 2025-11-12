//
//  DeviceHandlerCallback.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

protocol DeviceHandlerToCentralCallback {
    // CONNECTION
    
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
     Receive device info response
     */
    func onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler)

    /**
     Receive IMU data response
     */
    func onImuDataRsp(imuData: IMUData, handler: DeviceHandler)

    /**
     Receive battery level response
     */
    func onBatteryLevelRsp(batteryLevel: UInt16, handler: DeviceHandler)
}
