package com.syncrhrohealth.bandpass_ble_connection.core.command

import com.syncrhrohealth.bandpass_ble_connection.core.command.builder.CommandBuilder
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import java.nio.ByteBuffer
import java.nio.ByteOrder

// TODO: Review / 1000 from flutter site
object TimeStampSetCmd {
    fun send(epochTime: Long, handler: DeviceHandler) {
        // Divide by 1000 to convert from milliseconds to seconds
        val epochTimeBytes = formatEpochTime(epochTime / 1000)
        val builder = CommandBuilder.build(CommandCode.PACKET_CMD_TIMESTAMP_SET, epochTimeBytes)

        handler.write(builder)
    }

    /** Data format
     *
     *  uint64_t     epoch_time
     *
     * */

    private fun formatEpochTime(epochTime: Long): ByteArray {
        // The size of the epoch_time in bytes (uint64_t)
        val EPOCH_TIME_SIZE = 8
        val buffer = ByteBuffer.allocate(EPOCH_TIME_SIZE)
        buffer.order(ByteOrder.LITTLE_ENDIAN)
        buffer.putLong(epochTime)
        return buffer.array()
    }
}