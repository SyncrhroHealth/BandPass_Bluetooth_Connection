package com.syncrhrohealth.bandpass_ble_connection.ble


object BleConstant {
    const val SERVICE_UUID = "00001523-1212-efde-1523-78123abcd123"

    // Transfer command to device
    const val CENTRAL_TX_CHARACTERISTIC_UUID = "00001525-1212-efde-1523-78123abcd123"

    // Receive response from device
    const val CENTRAL_RX_CHARACTERISTIC_UUID = "00001524-1212-efde-1523-78123abcd123"

    const val MAX_ACCEPTED_RSSI = -70
    const val REQUEST_MTU_SIZE = 512

    const val CCC_BITS_UUID = "00002902-0000-1000-8000-00805f9b34fb"

    const val DEVICE_PREFIX = "BandPass"
}