//
//  CommandCode.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation

enum CommandCode: UInt8, CaseIterable {
    case packetCmdDeviceNameSet             = 1
    case packetCmdDeviceNameGet             = 2
    case packetCmdDeviceNameResp            = 3
    case packetCmdDeviceInfoGet             = 4
    case packetCmdDeviceInfoResp            = 5
    case packetCmdModeThermostatControlSet  = 6
    case packetCmdModeManualControlSet      = 7
    case packetCmdBasicInfoGet              = 8
    case packetCmdBasicInfoResp             = 9
    case packetCmdHotboxDataGet             = 10
    case packetCmdHotboxDataResp            = 11
    case packetCmdTimestampSet              = 12
    case packetCmdTimestampGet              = 13
    case packetCmdTimestampResp             = 14
    case packetCmdScheduleSet               = 15
    case packetCmdScheduleGet               = 16
    case packetCmdScheduleResp              = 17
    case packetCmdResetFuelLevelSet         = 18
    case packetCmdFuelCapacitySet           = 19
    case packetCmdFuelPumpSet               = 20
    // case packetCmdSeaLevelSet            = 21 ← Optional: REMOVE (not in Kotlin)
    case packetCmdTemperatureOffsetSet      = 22
    case packetCmdHeaterTuningSet           = 23
    case packetCmdHeaterTuningGet           = 24
    case packetCmdHeaterTuningResp          = 25
    case packetCmdOtaStart                  = 26
    case packetCmdOtaWrite                  = 27
    case packetCmdOtaWriteAndUpdate         = 28
    case packetCmdOtaStop                   = 29
    case packetCmdAck                       = 30

    var value: UInt8 {
        return self.rawValue
    }

    static func fromValue(_ value: UInt8) -> CommandCode? {
        return CommandCode(rawValue: value)
    }
}
