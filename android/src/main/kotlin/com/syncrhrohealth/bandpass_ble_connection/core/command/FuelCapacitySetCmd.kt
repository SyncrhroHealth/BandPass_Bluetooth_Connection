package com.syncrhrohealth.bandpass_ble_connection.core.command

import com.syncrhrohealth.bandpass_ble_connection.core.command.builder.CommandBuilder
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** Data format
 *
 *  float       fuel_capacity
 *
 * */

object FuelCapacitySetCmd {
    fun send(fuelCapacity: Float, handler: DeviceHandler) {
        val buffer = ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN)

        buffer.putFloat(fuelCapacity)

        val data = buffer.array()

        val packet = CommandBuilder.build(
            CommandCode.PACKET_CMD_FUEL_CAPACITY_SET,
            data
        )

        handler.write(packet)
    }
}