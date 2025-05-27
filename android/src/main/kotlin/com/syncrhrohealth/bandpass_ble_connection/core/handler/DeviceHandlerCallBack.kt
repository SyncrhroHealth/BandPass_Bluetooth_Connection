package com.syncrhrohealth.bandpass_ble_connection.core.handler

import com.syncrhrohealth.bandpass_ble_connection.core.model.DeviceInfo
import com.syncrhrohealth.bandpass_ble_connection.core.model.IMUData

interface DeviceHandlerCallBack {
    // Connection
    fun onConnected(handler: DeviceHandler)
    fun onDisConnected(handler: DeviceHandler)

    // Data response
    fun onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler)
    fun onImuDataRsp(imuRsp: IMUData, handler: DeviceHandler)
    fun onBatteryLevelRsp(batteryLevel: Int, isCharging: Boolean, handler: DeviceHandler)
}