package com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.event

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.content.Context
import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.ble.FoundDevice
import com.syncrhrohealth.bandpass_ble_connection.core.CoreHandler
import com.syncrhrohealth.bandpass_ble_connection.core.CoreHandlerCallBack
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.BasicInfo
import com.syncrhrohealth.bandpass_ble_connection.core.model.DeviceInfo
import com.syncrhrohealth.bandpass_ble_connection.core.model.HotBoxData
import com.syncrhrohealth.bandpass_ble_connection.core.model.Schedule
import com.syncrhrohealth.bandpass_ble_connection.core.model.TimeStamp
import com.syncrhrohealth.bandpass_ble_connection.plugin.ChannelNames
import com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.enum.DeviceCoreEvent
import com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.method.DeviceCoreMethodHelper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class DeviceCoreEventPlugin : FlutterPlugin,
    MethodChannel.MethodCallHandler, CoreHandlerCallBack {
    companion object {
        val TAG: String = DeviceCoreEventPlugin::class.java.simpleName
    }

    private val eventChannel = ChannelNames.DEVICE_CORE_EVENT_CHANNEL
    private lateinit var mContext: Context
    private val eventHandler = DeviceCoreEventHandler()


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        //NO IMPLEMENTATION
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        try {
            mContext = binding.applicationContext
            val eventChannel = EventChannel(binding.binaryMessenger, eventChannel)
            eventChannel.setStreamHandler(eventHandler)

            CoreHandler.getInstance(mContext).setListener(this)
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        //NO IMPLEMENTATION
    }

    //*************************** DEVICE CALLBACK HANDLER ******************************************

    @SuppressLint("MissingPermission")
    override fun onFoundDevice(device: FoundDevice) {
        Log.d(TAG, "onFoundDevice: ${device.btDevice.name}")

        val map = mapOf(
            "address" to device.btDevice.address,
            "name" to device.btDevice.name,
            "rssi" to device.rssi,
        )

        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_DEVICE_FOUND.value, map))
    }

    override fun onConnected(handler: DeviceHandler) {
        val device = DeviceCoreMethodHelper.getInstance(mContext).createDeviceMap(handler)
        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_DEVICE_CONNECTED.value, device))
    }

    override fun onDisConnected(handler: DeviceHandler) {
        val device = DeviceCoreMethodHelper.getInstance(mContext).createDeviceMap(handler)
        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_DEVICE_DISCONNECTED.value, device))
    }

    /** Devices */

    override fun onDeviceNameRsp(deviceName: String, handler: DeviceHandler) {
        val map = mapOf(
            "address" to handler.getDevice().getAddress(),
            "name" to deviceName,
        )

        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_DEVICE_NAME_RSP.value, map))
    }

    override fun onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler) {
        val map = mapOf(
            "address" to handler.getDevice().getAddress(),
            "fwVersion" to deviceInfo.fwVersion,
            "hwVersion" to deviceInfo.hwVersion,
            "macAddress" to deviceInfo.macAddress,
            "deviceName" to deviceInfo.deviceName,
        )

        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_DEVICE_INFO_RSP.value, map))
    }

    override fun onBasicInfoRsp(basicInfo: BasicInfo, handler: DeviceHandler) {
        val map = mapOf(
            "address" to handler.getDevice().getAddress(),
            "isTempSensorAttached" to basicInfo.isTempSensorAttached,
            "deviceOperationMode" to basicInfo.deviceOperationMode,
            "modeThermostatState" to basicInfo.modeThermostatState,
            "modeManualState" to basicInfo.modeManualState,
            "fuelLevel" to basicInfo.fuelLevel,
            "currentLevel" to basicInfo.currentLevel,
            "expectedLevel" to basicInfo.expectedLevel,
            "currentTemp" to basicInfo.currentTemp,
            "expectedTemp" to basicInfo.expectedTemp,
        )

        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_BASIC_INFO_RSP.value, map))
    }

    override fun onHotBoxDataRsp(hotBoxData: HotBoxData, handler: DeviceHandler) {
        val map = mapOf(
            "address" to handler.getDevice().getAddress(),
            "fuelLevel" to hotBoxData.fuelLevel,
            "fanSpeed" to hotBoxData.fanSpeed,
            "pumpRate" to hotBoxData.pumpRate,
            "glowPlugPower" to hotBoxData.glowPlugPower,
            "seaLevel" to hotBoxData.seaLevel,
            "batteryVoltage" to hotBoxData.batteryVoltage,
            "heaterTemp" to hotBoxData.heaterTemp,
            "fuelCapacity" to hotBoxData.fuelCapacity,
            "fuelPump" to hotBoxData.fuelPump,
            "tempOffset" to hotBoxData.tempOffset,
        )

        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_HOT_BOX_DATA_RSP.value, map))
    }

    override fun onTimeStampRsp(timeStamp: TimeStamp, handler: DeviceHandler) {
        val map = mapOf(
            "address" to handler.getDevice().getAddress(),
            "epoch" to timeStamp.epoch,
        )

        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_TIME_STAMP_RSP.value, map))
    }

    override fun onScheduleRsp(schedule: Schedule, handler: DeviceHandler) {
        val map = mapOf(
            "address" to handler.getDevice().getAddress(),
            "enableSchedule" to schedule.enableSchedule,
            "turnOnHour" to schedule.turnOn.hour,
            "turnOnMinute" to schedule.turnOn.minute,
            "turnOnAmOrPm" to schedule.turnOn.amOrPm,
            "turnOffHour" to schedule.turnOff.hour,
            "turnOffMinute" to schedule.turnOff.minute,
            "turnOffAmOrPm" to schedule.turnOff.amOrPm,
        )

        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_SCHEDULE_RSP.value, map))
    }
}