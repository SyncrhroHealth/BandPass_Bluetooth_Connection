package com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.method

import android.content.Context
import com.syncrhrohealth.bandpass_ble_connection.plugin.ChannelNames
import com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.enum.DeviceCoreMethod
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class DeviceCoreMethodPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var mContext: Context
    private val methodChannel = ChannelNames.DEVICE_CORE_METHOD_CHANNEL

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        try {
            mContext = binding.applicationContext
            val channel = MethodChannel(binding.binaryMessenger, methodChannel)
            channel.setMethodCallHandler(this)
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val args = call.arguments<ArrayList<*>>()

        when (call.method) {
            DeviceCoreMethod.IS_BLE_ENABLED.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).isBleEnabled(args, result)
            }

            DeviceCoreMethod.START_SCAN.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).startScan(args, result)
            }

            DeviceCoreMethod.STOP_SCAN.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).stopScan(args, result)
            }

            DeviceCoreMethod.CONNECT.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).connect(args, result)
            }

            DeviceCoreMethod.DISCONNECT.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).disconnect(args, result)
            }

            DeviceCoreMethod.RECONNECT.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).reconnect(args, result)
            }

            DeviceCoreMethod.RECONNECT_DEVICES.value -> {
                // TODO: Implement
            }

            DeviceCoreMethod.GET_DEVICE_NAME.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).getDeviceName(args, result)
            }

            DeviceCoreMethod.SET_DEVICE_NAME.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).setDeviceName(args, result)
            }

            DeviceCoreMethod.GET_DEVICE_INFO.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).getDeviceInfo(args, result)
            }

            DeviceCoreMethod.SET_THERMOSTAT_CONTROL_MODE.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).setThermostatControlMode(args, result)
            }

            DeviceCoreMethod.SET_MANUAL_CONTROL_MODE.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).setManualControlMode(args, result)
            }

            DeviceCoreMethod.GET_BASIC_INFO.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).getBasicInfo(args, result)
            }

            DeviceCoreMethod.GET_HOT_BOX_DATA.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).getHotBoxData(args, result)
            }

            DeviceCoreMethod.SET_TIME_STAMP.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).setTimeStamp(args, result)
            }

            DeviceCoreMethod.GET_TIME_STAMP.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).getTimeStamp(args, result)
            }

            DeviceCoreMethod.GET_SCHEDULE.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).getSchedule(args, result)
            }

            DeviceCoreMethod.SET_SCHEDULE.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).setSchedule(args, result)
            }

            DeviceCoreMethod.RESET_FUEL_LEVEL.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).resetFuelLevel(args, result)
            }

            DeviceCoreMethod.SET_FUEL_CAPACITY.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).setFuelCapacity(args, result)
            }

            DeviceCoreMethod.SET_FUEL_PUMP.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).setFuelPump(args, result)
            }

            DeviceCoreMethod.SET_SEA_LEVEL.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).setSeaLevel(args, result)
            }

            DeviceCoreMethod.SET_TEMP_OFFSET.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).setTempOffset(args, result)
            }

            else -> result.notImplemented()
        }
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        //NO IMPLEMENTATION
    }
}