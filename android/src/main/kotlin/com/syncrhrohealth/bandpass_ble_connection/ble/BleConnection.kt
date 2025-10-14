package com.syncrhrohealth.bandpass_ble_connection.ble

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothProfile
import android.content.Context
import android.os.*
import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.util.toHexString
import java.io.*
import java.util.UUID

@SuppressLint("MissingPermission")
class BleConnection(
    private val context: Context,
    private var device: BluetoothDevice,
    private val callback: BleConnectionCallBack
) {
    private val TAG = BleConnection::class.java.simpleName

    private var bluetoothGatt: BluetoothGatt? = null
    private var txCharacteristic: BluetoothGattCharacteristic? = null
    private var rxCharacteristic: BluetoothGattCharacteristic? = null
    private var batteryCharacteristic: BluetoothGattCharacteristic? = null

    private var subscribeNotificationCount = 0

    fun reconnect() {
        requestToConnect()
    }

    private val bluetoothGattCallback: BluetoothGattCallback = object : BluetoothGattCallback() {
        override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
            Log.d(
                TAG,
                "onConnectionStateChange: device: ${gatt.device.name}, " +
                        "address: ${gatt.device.address}, newState: $newState, " +
                        "status: $status, gatt.discoverServices(): ${gatt.discoverServices()}"
            )

            when (newState) {
                BluetoothProfile.STATE_CONNECTED -> {
                    gatt.discoverServices()
                }

                BluetoothProfile.STATE_DISCONNECTED -> {
                    closeGattConnection()
                    callback.onDisconnected(gatt.device)
                }
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
            Log.d(TAG, "onServicesDiscovered: ${status}")
            if (status == BluetoothGatt.GATT_SUCCESS) {
                discoverService(gatt)
//                setCharsNotification(gatt)
                gatt.requestMtu(BleConstant.REQUEST_MTU_SIZE)
            } else {
                closeGattConnection()
            }
        }

        /**
         * find characteristic in service
         */
        private fun discoverService(gatt: BluetoothGatt) {
            gatt.services.forEach { service ->
                Log.d(TAG, "discover Service service.uuid: ${service.uuid}")
                when (service.uuid.toString()) {
                    BleConstant.SERVICE_UUID -> {
                        Log.d(TAG, "SERVICE_UUID: ${service.characteristics}")
                        service.characteristics.forEach { characteristic ->
                            Log.d(
                                TAG,
                                "characteristics: ${characteristic.uuid.toString().lowercase()}"
                            )
                            when (characteristic.uuid.toString().lowercase()) {
                                BleConstant.CENTRAL_TX_CHARACTERISTIC_UUID -> {
                                    characteristic.writeType =
                                        BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                                    txCharacteristic = characteristic
                                }

                                BleConstant.CENTRAL_RX_CHARACTERISTIC_UUID -> {
                                    rxCharacteristic = characteristic
                                }
                            }
                        }
                    }

                    BleConstant.BATTERY_SERVICE_UUID -> {
                        Log.d(TAG, "BATTERY_SERVICE_UUID: ${service.characteristics}")
                        service.characteristics.forEach { characteristic ->
                            Log.d(
                                TAG,
                                "Battery characteristics: ${characteristic.uuid.toString().lowercase()}"
                            )
                            when (characteristic.uuid.toString().lowercase()) {
                                BleConstant.BATTERY_LEVEL_CHARACTERISTIC_UUID -> {
                                    batteryCharacteristic = characteristic
                                }
                            }
                        }
                    }

                    else -> {}
                }
            }
        }

        private fun setCharsNotification(gatt: BluetoothGatt) {
            subscribeNotificationCount += 1
            when (subscribeNotificationCount) {
                1 -> {
                    if (rxCharacteristic != null) {
                        gatt.setCharacteristicNotification(rxCharacteristic, true)

                        val uuid = UUID.fromString(BleConstant.CCC_BITS_UUID)
                        val descriptor = rxCharacteristic!!.getDescriptor(uuid)
                        descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE

                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                            descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                            gatt.writeDescriptor(descriptor)
                        } else {
                            gatt.writeDescriptor(
                                descriptor,
                                BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                            )
                        }
                    }
                }

                2 -> {
                    if (batteryCharacteristic != null) {
                        gatt.setCharacteristicNotification(batteryCharacteristic, true)

                        val uuid = UUID.fromString(BleConstant.CCC_BITS_UUID)
                        val descriptor = batteryCharacteristic!!.getDescriptor(uuid)
                        descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE

                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                            descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                            gatt.writeDescriptor(descriptor)
                        } else {
                            gatt.writeDescriptor(
                                descriptor,
                                BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                            )
                        }
                    }
                }
            }

            if (subscribeNotificationCount == 2) {
                callback.onConnected(gatt.device)
            }
        }

        override fun onMtuChanged(gatt: BluetoothGatt?, mtu: Int, status: Int) {
//            super.onMtuChanged(gatt, mtu, status)
            Log.d(TAG, "onMtuChanged status=$status mtu=$mtu")
            if (status == BluetoothGatt.GATT_SUCCESS && gatt != null) {
                // 2) Now enable notifications (CCCD writes)
                setCharsNotification(gatt)
            } else {
                // Fallback: still enable notifications, but you’ll have payload=20
                if (gatt != null) setCharsNotification(gatt)
            }
        }

        //-----------------------------------------------------------------------------------------
        //	Callback triggered as a result of a remote characteristic notification.
        //-----------------------------------------------------------------------------------------
        //BELOW SDK 33
        override fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic
        ) {
            when (characteristic.uuid.toString().lowercase()) {
                BleConstant.CENTRAL_RX_CHARACTERISTIC_UUID -> {
                    callback.onDataReceived(gatt.device, characteristic.value)
                }

                BleConstant.BATTERY_LEVEL_CHARACTERISTIC_UUID -> {
                    callback.onBatteryLevelReceived(gatt.device, characteristic.value)
                }
            }
        }

        //ABOVE SDK 33
        override fun onCharacteristicChanged(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            value: ByteArray
        ) {
            when (characteristic.uuid.toString().lowercase()) {
                BleConstant.CENTRAL_RX_CHARACTERISTIC_UUID -> {
                    callback.onDataReceived(gatt.device, value)
                }

                BleConstant.BATTERY_LEVEL_CHARACTERISTIC_UUID -> {
                    callback.onBatteryLevelReceived(gatt.device, value)
                }
            }
        }

        // API ≤ 32
        override fun onCharacteristicRead(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            status: Int
        ) {
            if (status == BluetoothGatt.GATT_SUCCESS &&
                characteristic.uuid.toString().lowercase() == BleConstant.BATTERY_LEVEL_CHARACTERISTIC_UUID
            ) {
                callback.onBatteryLevelReceived(gatt.device, characteristic.value)
            }
        }

        // API 33+
        override fun onCharacteristicRead(
            gatt: BluetoothGatt,
            characteristic: BluetoothGattCharacteristic,
            value: ByteArray,
            status: Int
        ) {
            if (status == BluetoothGatt.GATT_SUCCESS &&
                characteristic.uuid.toString().lowercase() == BleConstant.BATTERY_LEVEL_CHARACTERISTIC_UUID
            ) {
                callback.onBatteryLevelReceived(gatt.device, value)
            }
        }


        override fun onDescriptorWrite(
            gatt: BluetoothGatt?,
            descriptor: BluetoothGattDescriptor?,
            status: Int
        ) {
            super.onDescriptorWrite(gatt, descriptor, status)
            Log.d(TAG, "onDescriptorWrite ${descriptor?.characteristic?.uuid}, status: $status")
            if (gatt != null) {
                setCharsNotification(gatt)
            }
        }
    }

    /** Reads Battery Level once (0–100 %). */
    fun readBatteryLevel(): Boolean {
        val char = batteryCharacteristic
        return if (bluetoothGatt != null && char != null) {
            // Ensure the characteristic has the READ property
            if (char.properties and BluetoothGattCharacteristic.PROPERTY_READ != 0) {
                bluetoothGatt!!.readCharacteristic(char)     // API 21-34
                true
            } else {
                Log.w(TAG, "Battery Level characteristic is not readable")
                false
            }
        } else {
            Log.w(TAG, "Battery characteristic not discovered yet")
            false
        }
    }


    private fun closeGattConnection() {
        bluetoothGatt?.let { gatt ->
            callback.onDisconnected(gatt.device)
            gatt.disconnect()
            gatt.close()
            bluetoothGatt = null
            subscribeNotificationCount = 0
        }
    }

    fun requestToConnect(autoConnect: Boolean = false): Boolean {
        if (bluetoothGatt != null) {
            bluetoothGatt?.disconnect()
            bluetoothGatt?.close()
            bluetoothGatt = null
        }

        try {
            bluetoothGatt =
                device.connectGatt(
                    context,
                    autoConnect,
                    bluetoothGattCallback,
                    BluetoothDevice.TRANSPORT_LE
                )
            return true
        } catch (exception: Exception) {
            exception.printStackTrace()
            return false
        }
    }

    fun requestToDisconnect() {
        closeGattConnection()
    }

    fun write(data: String) {
        writeData(data.toByteArray())
    }

    fun write(data: ByteArray) {
        writeData(data)
    }

    private fun writeData(data: ByteArray) {
        try {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                txCharacteristic?.value = data
                val result = bluetoothGatt?.writeCharacteristic((txCharacteristic))

                Log.d(
                    TAG,
                    "$TAG - writeData: $result: ${data.toHexString()}"
                )
            } else {
                val result = bluetoothGatt?.writeCharacteristic(
                    txCharacteristic!!,
                    data,
                    BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                )

                Log.d(
                    TAG,
                    "$TAG - writeData: $result: ${data.toHexString()}"
                )
            }
        } catch (ex: IOException) {
            ex.printStackTrace()
        }
    }
}