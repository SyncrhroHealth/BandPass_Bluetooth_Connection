package com.syncrhrohealth.bandpass_ble_connection.ble


object BleConstant {
    const val SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"

    // Transfer command to device
    const val CENTRAL_TX_CHARACTERISTIC_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"

    // Receive response from device
    const val CENTRAL_RX_CHARACTERISTIC_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"

    const val MAX_ACCEPTED_RSSI = -70
    const val REQUEST_MTU_SIZE = 512

    const val CCC_BITS_UUID = "00002902-0000-1000-8000-00805f9b34fb"

    const val DEVICE_PREFIX = "BANDPASS"
}