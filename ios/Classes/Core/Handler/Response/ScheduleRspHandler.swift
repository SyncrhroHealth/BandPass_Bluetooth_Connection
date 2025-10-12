//
//  ScheduleRspHandler.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Time Schedule Data format:
/// - `uint8_t hour`
/// - `uint8_t minute`
/// - `uint8_t am_pm` (0: AM, 1: PM)

/// Schedule Data format:
/// - `uint8_t enable_schedule` (0: Not enabled, 1: Enabled)
/// - `time_schedule_t turn_on`
/// - `time_schedule_t turn_off`
struct ScheduleRspHandler {
    static func handle(data: Data, handler: DeviceHandler) {
        guard data.count >= 7 else {
            print("ScheduleRspHandler - Error: Not enough data received")
            return
        }

        do {
            // Extract enable_schedule (1 byte)
            let enableSchedule = Int(data[0]) // Extract as UInt8 and convert to Int

            // Extract time_schedule_t turn_on (3 bytes)
            let onHour   = Int(data[1])
            let onMinute = Int(data[2])
            let onAmPm   = Int(data[3])

            // Extract time_schedule_t turn_off (3 bytes)
            let offHour   = Int(data[4])
            let offMinute = Int(data[5])
            let offAmPm   = Int(data[6])

            let turnOn = TimeSchedule(hour: onHour, minute: onMinute, amOrPm: onAmPm)
            let turnOff = TimeSchedule(hour: offHour, minute: offMinute, amOrPm: offAmPm)

            let schedule = Schedule(enableSchedule: enableSchedule, turnOn: turnOn, turnOff: turnOff)

            handler.getCallBackToCentral()?.onScheduleRsp(schedule: schedule, handler: handler)
        } catch {
            print("ScheduleRspHandler - Error parsing data: \(error)")
        }
    }
}
