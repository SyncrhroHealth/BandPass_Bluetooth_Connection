package com.syncrhrohealth.bandpass_ble_connection.core.handler

import android.bluetooth.BluetoothDevice
import android.content.Context
import android.util.Log
import com.syncrhrohealth.bandpass_ble_connection.ble.BleConnectionCallBack
import com.syncrhrohealth.bandpass_ble_connection.ble.BlePeripheral
import com.syncrhrohealth.bandpass_ble_connection.core.parser.DataParser
import com.syncrhrohealth.bandpass_ble_connection.util.ThreadPoolCreater

class DeviceHandler(
    context: Context,
    device: BluetoothDevice,
    val callBack: DeviceHandlerCallBack
) :
    BleConnectionCallBack {

    private val peripheral: BlePeripheral = BlePeripheral(context, device, this)

    private var parser: DataParser = DataParser(this) {
        ReceiveDataHandler.handle(it, this)
    }

    val executor = ThreadPoolCreater.create()

    init {
        executor.submit(parser)
    }

    override fun onConnected(connection: BluetoothDevice) {
        callBack.onConnected(this)
    }

    override fun onDisconnected(connection: BluetoothDevice) {
        callBack.onDisConnected(this)
    }

    override fun onDataReceived(connection: BluetoothDevice, byteArray: ByteArray) {
        parser.push(byteArray)
    }

    override fun onBatteryLevelReceived(connection: BluetoothDevice, byteArray: ByteArray) {
        // Handle battery level data if needed
        Log.e(TAG, "onBatteryLevelReceived: array: $byteArray")
        peripheral.batteryLevel = byteArray[0].toInt()
        Log.e(TAG, "Battery Level: ${peripheral.batteryLevel}")
        callBack.onBatteryLevelRsp(
            peripheral.batteryLevel,
            this
        )
    }

    fun requestToConnect(autoConnect: Boolean = false) {
        peripheral.requestToConnect(autoConnect)
    }

    fun reconnect() {
        peripheral.reconnect()
    }

    fun requestToDisconnect() {
        peripheral.requestToDisconnect()
    }

    fun isEqual(address: String): Boolean {
        return peripheral.getAddress() == address
    }

    fun getDevice(): BlePeripheral {
        return peripheral
    }

    fun write(data: ByteArray) {
        peripheral.write(data)
    }
}