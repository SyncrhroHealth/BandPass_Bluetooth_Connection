package com.syncrhrohealth.bandpass_ble_connection.util

fun ByteArray.toHexString(): String {
    return joinToString(prefix = "[", postfix = "]") {
        String.format("%02X", it)
    }
}