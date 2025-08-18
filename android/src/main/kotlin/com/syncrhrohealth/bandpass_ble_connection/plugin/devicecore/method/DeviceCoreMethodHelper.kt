package com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.method

import android.content.Context
import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.ble.BleStateController
import com.syncrhrohealth.bandpass_ble_connection.core.CoreHandler
import com.syncrhrohealth.bandpass_ble_connection.core.command.DeviceInfoGetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.util.SingletonHolder
import io.flutter.plugin.common.MethodChannel


class DeviceCoreMethodHelper private constructor(private val context: Context) {
    companion object : SingletonHolder<DeviceCoreMethodHelper, Context>(::DeviceCoreMethodHelper)

    /** Connection */

    fun isBleEnabled(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            val enable = BleStateController.getInstance(context).isBluetoothEnabled
            result.success(enable)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }


    fun startScan(args: Any?, result: MethodChannel.Result) {
        val origin: String? = when (args) {
            is java.util.ArrayList<*> -> args.firstOrNull() as? String
            is List<*>                -> args.firstOrNull() as? String
            is Map<*, *>              -> args["origin"] as? String
            is String                 -> args
            null                      -> null
            else                      -> args.toString()
        }

        android.util.Log.w("DeviceCore", "startScan origin:\n${origin ?: "<no-origin>"}")

        if (origin == null) {                 // <-- DO NOT proceed
            result.error(
                "MISSING_ORIGIN",
                "startScan must be invoked with an 'origin' (Dart StackTrace).",
                null
            )
            return
        }

        try {
            CoreHandler.getInstance(context).startScan()
            result.success(true)
        } catch (t: Throwable) {
            android.util.Log.e("DeviceCore", "startScan failed", t)
            result.success(false)
        }
    }



    fun stopScan(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            CoreHandler.getInstance(context).stopScan()
            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun connect(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }
            val address = args[0] as String
            CoreHandler.getInstance(context).requestToConnect(address)
            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun disconnect(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }
            val address = args[0] as String
            CoreHandler.getInstance(context).requestToDisconnect(address)
            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun reconnect(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }
            val address = args[0] as String
            CoreHandler.getInstance(context).reconnect(address)
            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    /** Command */
    fun getDeviceInfo(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                DeviceInfoGetCmd.send(handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun createDeviceMap(handler: DeviceHandler): Map<String, Any> {
        return mapOf(
            /// When turn off Bluetooth, can't use getName() function
            "name" to handler.getDevice().getName(),
            "address" to handler.getDevice().getAddress(),
//            "isCharging" to handler.getDevice().isCharging,
//            "batteryLevel" to handler.getDevice().batteryLevel,
//            "hwVersion" to handler.getDevice().hwVersion,
//            "fwVersion" to handler.getDevice().fwVersion,
//            "model" to handler.getDevice().model,
//            "serialNumber" to handler.getDevice().serialNumber
        )
    }
}