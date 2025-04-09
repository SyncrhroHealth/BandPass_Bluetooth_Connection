package com.syncrhrohealth.bandpass_ble_connection.core.command

import com.syncrhrohealth.bandpass_ble_connection.core.command.builder.CommandBuilder
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** Data format
 *
 *  uint16_t    sea_level
 *
 * */

object SeaLevelSetCmd {
    fun send(seaLevel: Int, handler: DeviceHandler) {
        val buffer = ByteBuffer.allocate(2).order(ByteOrder.LITTLE_ENDIAN)

        buffer.putShort(seaLevel.toShort())

        val data = buffer.array()

        val packet = CommandBuilder.build(
            CommandCode.PACKET_CMD_SEA_LEVEL_SET,
            data
        )

        handler.write(packet)
    }
}