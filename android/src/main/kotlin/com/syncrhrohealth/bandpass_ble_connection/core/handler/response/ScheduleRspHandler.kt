package com.syncrhrohealth.bandpass_ble_connection.core.handler.response

import com.syncrhrohealth.bandpass_ble_connection.core.handler.DeviceHandler
import com.syncrhrohealth.bandpass_ble_connection.core.model.Schedule
import com.syncrhrohealth.bandpass_ble_connection.core.model.TimeSchedule

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

object ScheduleRspHandler {
    fun handle(data: ByteArray, handler: DeviceHandler) {
        try {
            if (data.size < 7) {
                return
            }

            val enableSchedule = data[0].toInt() and 0xFF

            val onHour   = data[1].toInt() and 0xFF
            val onMinute = data[2].toInt() and 0xFF
            val onAmPm   = data[3].toInt() and 0xFF

            val offHour   = data[4].toInt() and 0xFF
            val offMinute = data[5].toInt() and 0xFF
            val offAmPm   = data[6].toInt() and 0xFF

            val turnOn = TimeSchedule(onHour, onMinute, onAmPm)
            val turnOff = TimeSchedule(offHour, offMinute, offAmPm)

            val schedule = Schedule(enableSchedule, turnOn, turnOff)

            handler.callBack.onScheduleRsp(schedule, handler)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}