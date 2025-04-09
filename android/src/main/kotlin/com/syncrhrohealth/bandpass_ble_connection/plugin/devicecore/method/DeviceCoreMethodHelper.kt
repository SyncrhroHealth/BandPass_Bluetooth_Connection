package com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.method

import android.content.Context
import com.syncrhrohealth.bandpass_ble_connection.ble.BleStateController
import com.syncrhrohealth.bandpass_ble_connection.core.CoreHandler
import com.syncrhrohealth.bandpass_ble_connection.core.command.BasicInfoGetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.DeviceInfoGetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.DeviceNameGetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.DeviceNameSetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.FuelCapacitySetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.FuelPumpSetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.HotBoxDataGetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.ManualControlSetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.ResetFuelLevelSetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.ScheduleGetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.ScheduleSetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.SeaLevelSetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.TempOffsetSetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.ThermostatControlSetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.TimeStampGetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.command.TimeStampSetCmd
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.Schedule
import com.syncrhrohealth.bandpass_ble_connection.core.model.TimeSchedule
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


    fun startScan(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            CoreHandler.getInstance(context).startScan()
            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
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

    fun getDeviceName(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                DeviceNameGetCmd.send(handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun setDeviceName(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val name = args[1] as String
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                DeviceNameSetCmd.send(name, handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

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

    fun setThermostatControlMode(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val command = args[1] as Int
            val expectedTemp = (args[2] as Double).toFloat()
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                ThermostatControlSetCmd.send(command, expectedTemp, handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun setManualControlMode(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val command = args[1] as Int
            val expectedTemp = (args[2] as Double).toFloat()
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                ManualControlSetCmd.send(command, expectedTemp, handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun getBasicInfo(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                BasicInfoGetCmd.send(handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun getHotBoxData(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                HotBoxDataGetCmd.send(handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }


    fun setTimeStamp(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val epoch = args[1] as Long
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                TimeStampSetCmd.send(epoch, handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun getTimeStamp(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                TimeStampGetCmd.send(handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun getSchedule(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                ScheduleGetCmd.send(handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun setSchedule(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val enableSchedule = args[1] as Int
            val turnOnHour = args[2] as Int
            val turnOnMinute = args[3] as Int
            val turnOnAmPm = args[4] as Int
            val turnOffHour = args[5] as Int
            val turnOffMinute = args[6] as Int
            val turnOffAmPm = args[7] as Int

            val schedule = Schedule(
                enableSchedule,
                TimeSchedule(turnOnHour, turnOnMinute, turnOnAmPm),
                TimeSchedule(turnOffHour, turnOffMinute, turnOffAmPm)
            )

            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                ScheduleSetCmd.send(schedule, handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun resetFuelLevel(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                ResetFuelLevelSetCmd.send(handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun setFuelCapacity(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val fuelCapacity = (args[1] as Double).toFloat()
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                FuelCapacitySetCmd.send(fuelCapacity, handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun setFuelPump(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val fuelPump = (args[1] as Double).toFloat()
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                FuelPumpSetCmd.send(fuelPump, handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun setSeaLevel(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val seaLevel = args[1] as Int
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                SeaLevelSetCmd.send(seaLevel, handler)
            }

            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    fun setTempOffset(args: ArrayList<*>?, result: MethodChannel.Result) {
        try {
            if (args == null) {
                result.success(false)
                return
            }

            val address = args[0] as String
            val tempOffset = (args[1] as Double).toFloat()
            val handler = CoreHandler.getInstance(context).getDevice(address)

            handler?.let {
                TempOffsetSetCmd.send(tempOffset, handler)
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