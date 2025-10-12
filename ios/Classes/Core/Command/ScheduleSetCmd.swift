//
//  ScheduleSetCmd.swift
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
struct ScheduleSetCmd {
    static func send(schedule: Schedule, handler: DeviceHandler) {
        var data = Data()

        // 1. Convert `enableSchedule` (1 byte)
        let enableScheduleData = Data.UInt16ToData(UInt16(schedule.enableSchedule), byteOder: .LittleEndian)
        data.append(enableScheduleData.prefix(1)) // Take only the first byte since it's `uint8_t`

        // 2. Convert `turnOn` (hour, minute, am/pm - 3 bytes)
        let turnOnData = Data([
            UInt8(schedule.turnOn.hour),
            UInt8(schedule.turnOn.minute),
            UInt8(schedule.turnOn.amOrPm)
        ])
        data.append(turnOnData)

        // 3. Convert `turnOff` (hour, minute, am/pm - 3 bytes)
        let turnOffData = Data([
            UInt8(schedule.turnOff.hour),
            UInt8(schedule.turnOff.minute),
            UInt8(schedule.turnOff.amOrPm)
        ])
        data.append(turnOffData)

        // 4. Build the packet with CommandBuilder
        let packet = CommandBuilder.build(commandCode: .packetCmdScheduleSet, data: data)

        // 5. Send packet
        handler.write(data: packet)
    }
}
