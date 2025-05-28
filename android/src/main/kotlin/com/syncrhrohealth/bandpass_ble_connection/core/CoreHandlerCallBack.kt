package com.syncrhrohealth.bandpass_ble_connection.core

import android.bluetooth.BluetoothDevice
import com.syncrhrohealth.bandpass_ble_connection.ble.FoundDevice
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.DeviceInfo
import com.syncrhrohealth.bandpass_ble_connection.core.model.IMUData
import com.syncrhrohealth.bandpass_ble_connection.core.model.TimeStamp

interface CoreHandlerCallBack {
    // Connection
    fun onFoundDevice(device: FoundDevice)
    fun onConnected(handler: DeviceHandler)
    fun onDisConnected(handler: DeviceHandler)

    // Data response
    fun onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler)
    fun onImuDataRsp(imuRsp: IMUData, handler: DeviceHandler)
    fun onBatteryLevelRsp(batteryLevel: Int, handler: DeviceHandler)
}