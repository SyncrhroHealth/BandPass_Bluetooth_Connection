package com.syncrhrohealth.bandpass_ble_connection.core.model

data class HotBoxData(
    val fuelLevel: Int,
    val fanSpeed: Int,
    val pumpRate: Int,
    val glowPlugPower: Int,
    val seaLevel: Int,
    //
    val batteryVoltage: Float,
    val heaterTemp: Float,
    val fuelCapacity: Float,
    val fuelPump: Float,
    val tempOffset: Float,
)
