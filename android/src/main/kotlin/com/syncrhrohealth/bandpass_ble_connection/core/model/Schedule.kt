package com.syncrhrohealth.bandpass_ble_connection.core.model

data class Schedule(
    val enableSchedule: Int,
    val turnOn: TimeSchedule,
    val turnOff: TimeSchedule,
)
