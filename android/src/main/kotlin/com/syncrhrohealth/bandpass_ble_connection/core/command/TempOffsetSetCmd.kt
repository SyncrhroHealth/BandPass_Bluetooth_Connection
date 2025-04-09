package com.syncrhrohealth.bandpass_ble_connection.core.command

import com.syncrhrohealth.bandpass_ble_connection.core.command.builder.CommandBuilder
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** Data format
 *
 *  float       temperature_offset
 *
 * */

object TempOffsetSetCmd {
    fun send(tempOffset: Float, handler: DeviceHandler) {
        val buffer = ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN)

        buffer.putFloat(tempOffset)

        val data = buffer.array()

        val packet = CommandBuilder.build(
            CommandCode.PACKET_CMD_TEMPERATURE_OFFSET_SET,
            data
        )

        handler.write(packet)
    }

}