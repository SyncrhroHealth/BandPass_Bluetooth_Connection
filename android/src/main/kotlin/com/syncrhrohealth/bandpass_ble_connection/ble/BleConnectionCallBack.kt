package com.syncrhrohealth.bandpass_ble_connection.ble

import android.bluetooth.BluetoothDevice

interface BleConnectionCallBack {
    fun onConnected(connection: BluetoothDevice)
    fun onDisconnected(connection: BluetoothDevice)

    // For live data, notified from Central RX characteristic
    fun onDataReceived(connection: BluetoothDevice, byteArray: ByteArray)

    // For live data, notified from Central RX characteristic
    fun onBatteryLevelReceived(connection: BluetoothDevice, byteArray: ByteArray)
}