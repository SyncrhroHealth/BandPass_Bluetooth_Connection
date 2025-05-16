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

            DeviceCoreMethod.GET_DEVICE_INFO.value -> {
                DeviceCoreMethodHelper.getInstance(mContext).getDeviceInfo(args, result)
            }

            else -> result.notImplemented()
        }
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        //NO IMPLEMENTATION
    }
}