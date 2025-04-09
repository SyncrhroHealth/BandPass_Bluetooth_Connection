package com.syncrhrohealth.bandpass_ble_connection.ble

import android.bluetooth.BluetoothDevice

data class FoundDevice(
    val btDevice: BluetoothDevice,
    val rssi : Int,
)
