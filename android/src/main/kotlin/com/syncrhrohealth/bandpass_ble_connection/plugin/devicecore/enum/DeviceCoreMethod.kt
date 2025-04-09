package com.syncrhrohealth.bandpass_ble_connection.plugin.devicecore.enum

/** Make sure the method value matches the DeviceCoreMethod on Flutter side */
enum class DeviceCoreMethod(val value: String) {
    // Permissions
    IS_BLE_ENABLED("isBleEnabled"),

    // Scanning
    START_SCAN("startScan"),
    STOP_SCAN("stopScan"),

    // Connection
    CONNECT("connect"),
    DISCONNECT("disconnect"),
    RECONNECT("reconnect"),
    RECONNECT_DEVICES("reconnectDevices"),

    // Device commands
    GET_DEVICE_NAME("getDeviceName"),
    SET_DEVICE_NAME("setDeviceName"),
    GET_DEVICE_INFO("getDeviceInfo"),
    SET_THERMOSTAT_CONTROL_MODE("setThermostatControlMode"),
    SET_MANUAL_CONTROL_MODE("setManualControlMode"),
    GET_BASIC_INFO("getBasicInfo"),
    GET_HOT_BOX_DATA("getHotBoxData"),
    SET_TIME_STAMP("setTimeStamp"),
    GET_TIME_STAMP("getTimeStamp"),
    GET_SCHEDULE("getSchedule"),
    SET_SCHEDULE("setSchedule"),
    RESET_FUEL_LEVEL("resetFuelLevel"),
    SET_FUEL_CAPACITY("setFuelCapacity"),
    SET_FUEL_PUMP("setFuelPump"),
    SET_SEA_LEVEL("setSeaLevel"),
    SET_TEMP_OFFSET("setTempOffset"),
}
