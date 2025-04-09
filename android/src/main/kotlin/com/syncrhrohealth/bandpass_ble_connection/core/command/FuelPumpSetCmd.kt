package com.syncrhrohealth.bandpass_ble_connection.core.command

import com.syncrhrohealth.bandpass_ble_connection.core.command.builder.CommandBuilder
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** Data format
 *
 *  float       fuel_pump
 *
 * */

object FuelPumpSetCmd {
    fun send(fuelPump: Float, handler: DeviceHandler) {
        val buffer = ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN)

        buffer.putFloat(fuelPump)

        val data = buffer.array()

        val packet = CommandBuilder.build(
            CommandCode.PACKET_CMD_FUEL_PUMP_SET,
            data
        )

        handler.write(packet)
    }
}