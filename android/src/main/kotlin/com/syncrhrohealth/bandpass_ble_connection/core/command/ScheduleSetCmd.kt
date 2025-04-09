package com.syncrhrohealth.bandpass_ble_connection.core.command

import com.syncrhrohealth.bandpass_ble_connection.core.command.builder.CommandBuilder
import com.syncrhrohealth.bandpass_ble_connection.core.enum.CommandCode
import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.Schedule
import java.nio.ByteBuffer
import java.nio.ByteOrder

/** Time Schedule Data format
 *
 *  uint8_t             hour
 *  uint8_t             minute
 *  uint8_t             am_pm               (0: AM; 1: PM)
 *
 * */

/** Schedule Data format
 *
 *  uint8_t             enable_schedule     (0: Not enable, 1 : Enable schedule)
 *  time_schedule_t     turn_on
 *  time_schedule_t     turn_off
 *
 * */

object ScheduleSetCmd {
    fun send(
        schedule: Schedule,
        handler: DeviceHandler
    ) {
        // Allocate 7 bytes for the data section
        val dataBuffer = ByteBuffer.allocate(7).order(ByteOrder.LITTLE_ENDIAN)

        dataBuffer.put(schedule.enableSchedule.toByte())

        dataBuffer.put(schedule.turnOn.hour.toByte())
        dataBuffer.put(schedule.turnOn.minute.toByte())
        dataBuffer.put(schedule.turnOn.amOrPm.toByte())

        dataBuffer.put(schedule.turnOff.hour.toByte())
        dataBuffer.put(schedule.turnOff.minute.toByte())
        dataBuffer.put(schedule.turnOff.amOrPm.toByte())

        val data = dataBuffer.array()

        val packet = CommandBuilder.build(
            CommandCode.PACKET_CMD_SCHEDULE_SET,
            data
        )

        handler.write(packet)
    }
}