package com.syncrhrohealth.bandpass_ble_connection.core

import android.bluetooth.BluetoothDevice
import com.syncrhrohealth.bandpass_ble_connection.ble.FoundDevice
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.BasicInfo
import com.syncrhrohealth.bandpass_ble_connection.core.model.DeviceInfo
import com.syncrhrohealth.bandpass_ble_connection.core.model.HotBoxData
import com.syncrhrohealth.bandpass_ble_connection.core.model.Schedule
import com.syncrhrohealth.bandpass_ble_connection.core.model.TimeStamp

interface CoreHandlerCallBack {
     // Connection
     fun onFoundDevice(device: FoundDevice)
     fun onConnected(handler: DeviceHandler)
     fun onDisConnected(handler: DeviceHandler)

     // Data response
     fun onDeviceNameRsp(deviceName: String, handler: DeviceHandler)
     fun onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler)
     fun onBasicInfoRsp(basicInfo: BasicInfo, handler: DeviceHandler)
     fun onHotBoxDataRsp(hotBoxData: HotBoxData, handler: DeviceHandler)
     fun onTimeStampRsp(timeStamp: TimeStamp, handler: DeviceHandler)
     fun onScheduleRsp(schedule: Schedule, handler: DeviceHandler)
}