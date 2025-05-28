package com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.event

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.content.Context
import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.ble.FoundDevice
import com.syncrhrohealth.bandpass_ble_connection.core.CoreHandler
import com.syncrhrohealth.bandpass_ble_connection.core.CoreHandlerCallBack
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.DeviceInfo
import com.syncrhrohealth.bandpass_ble_connection.core.model.IMUData
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

    override fun onImuDataRsp(imuRsp: IMUData, handler: DeviceHandler) {
        val map = mapOf(
            "address" to handler.getDevice().getAddress(),
            "timestampMs" to imuRsp.timestampMs,
            "count" to imuRsp.count,
            "accelX" to imuRsp.accelX,
            "accelY" to imuRsp.accelY,
            "accelZ" to imuRsp.accelZ,
            "gyroX" to imuRsp.gyrosX,
            "gyroY" to imuRsp.gyrosY,
            "gyroZ" to imuRsp.gyrosZ,
            "adcRaw" to imuRsp.adcRaw
        )

        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_IMU_DATA_RSP.value, map))
    }

    override fun onBatteryLevelRsp(batteryLevel: Int, handler: DeviceHandler) {
        val map = mapOf(
            "address" to handler.getDevice().getAddress(),
            "level" to batteryLevel,
        )

        eventHandler.send(DeviceCoreEventTask(DeviceCoreEvent.ON_BATTERY_LEVEL_RSP.value, map))
    }
}