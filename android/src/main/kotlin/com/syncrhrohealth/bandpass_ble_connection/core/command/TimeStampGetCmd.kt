package com.syncrhrohealth.bandpass_ble_connection.core.command

import com.syncrhrohealth.bandpass_ble_connection.core.command.builder.CommandBuilder
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler


object TimeStampGetCmd {
    fun send(handler: DeviceHandler) {
        val builder = CommandBuilder.build(CommandCode.PACKET_CMD_TIMESTAMP_GET)
        handler.write(builder)
    }
}