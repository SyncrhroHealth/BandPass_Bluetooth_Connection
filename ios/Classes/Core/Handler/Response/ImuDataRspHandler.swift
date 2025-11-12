//
//  ImuDataRspHandler.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation

/**
 * IMU Data Response Handler
 *
 * Parses the raw payload (including the single-byte type) into IMUData, using
 * integer and fractional components for each sensor reading (as in Python reference).
 *
 * Data format (Packet.data):
 * Byte 0      : Payload type tag (0x03 = IMU data)
 * Byte 1–2    : Count (big-endian format)
 * Byte 3–10   : Accelerometer X (int32 LE integer + int32 LE fractional parts)
 * Byte 11–18  : Accelerometer Y (int32 LE integer + int32 LE fractional parts)
 * Byte 19–26  : Accelerometer Z (int32 LE integer + int32 LE fractional parts)
 * Byte 27–34  : Gyroscope X (int32 LE integer + int32 LE fractional parts)
 * Byte 35–42  : Gyroscope Y (int32 LE integer + int32 LE fractional parts)
 * Byte 43–50  : Gyroscope Z (int32 LE integer + int32 LE fractional parts)
 * Byte 51     : ADC tag (0x02)
 * Byte 52–53  : ADC raw value (big-endian uint16)
 * Byte 54     : RTC tag (0x04)
 * Byte 55–58  : RTC seconds (big-endian uint32)
 * Byte 59–60  : RTC milliseconds (big-endian uint16)
 * Byte 61     : Optional terminator tag – discard if present
 */

private let UTC_TZ = TimeZone(identifier: "UTC")!
private let DATE_FMT: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd"
    fmt.timeZone = UTC_TZ
    fmt.locale = Locale(identifier: "en_US_POSIX")
    return fmt
}()
private let TIME_FMT: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "HH:mm:ss.SSS"
    fmt.timeZone = UTC_TZ
    fmt.locale = Locale(identifier: "en_US_POSIX")
    return fmt
}()

/** Device's "RTC base" (seconds from 1970-01-01 to 2000-01-01) */
private let RTC_BASE_OFFSET: Int64 = 946_684_800

struct ImuDataRspHandler {
    static func handle(data: Data, handler: DeviceHandler) {
        // print("ImuDataRspHandler - handle: len=\(data.count), bytes=\(data.toHexString())")
        
        guard data.count >= 51 else {
            print("ImuDataRspHandler - Error: Not enough data received (minimum 51 bytes)")
            return
        }
        
        do {
            // 0: payload type
            guard data[0] == 0x03 else {
                print("ImuDataRspHandler - Error: Invalid payload type: \(data[0])")
                return
            }
            
            // 1–2: count (big-endian)
            let count = Int((UInt16(data[1]) << 8) | UInt16(data[2]))
            
            // Parse sensor value: 32-bit integer part + 32-bit fractional part (1e6 scale)
            func parseSensor(offset: Int) -> Float {
                let intPartData = data.subdata(in: offset..<(offset + 4))
                let fracPartData = data.subdata(in: (offset + 4)..<(offset + 8))
                
                let intPart = intPartData.toInt32(byteOrder: .LittleEndian)
                let fracPart = fracPartData.toInt32(byteOrder: .LittleEndian)
                
                return Float(intPart) + Float(fracPart) / 1_000_000.0
            }
            
            // Accelerometer (first sample)
            let accelX = parseSensor(offset: 3)
            let accelY = parseSensor(offset: 11)
            let accelZ = parseSensor(offset: 19)
            
            // Gyroscope (first sample)
            let gyroX = parseSensor(offset: 27)
            let gyroY = parseSensor(offset: 35)
            let gyroZ = parseSensor(offset: 43)
            
            // ADC: tag + big-endian uint16
            guard data.count >= 54 else {
                print("ImuDataRspHandler - Error: Not enough data for ADC (minimum 54 bytes)")
                return
            }
            
            guard data[51] == 0x02 else {
                print("ImuDataRspHandler - Error: Invalid ADC tag: \(data[51])")
                return
            }
            
            let adcData = data.subdata(in: 52..<54)
            let adcRaw = Int(adcData.toUInt16(byteOrder: .BigEndian))
            
            // ─── RTC: tag, seconds (uint32 BE), milliseconds (uint16 BE) ────────────
            var dateStr: String = ""
            var timeStr: String = ""
            
            if data.count >= 61 && data[54] == 0x04 {
                // seconds 55-58 (big-endian)
                let secsData = data.subdata(in: 55..<59)
                let secs = Int64(secsData.toUInt32(byteOrder: .BigEndian))
                
                // ms 59-60 (big-endian)
                let msData = data.subdata(in: 59..<61)
                let ms = Int64(msData.toUInt16(byteOrder: .BigEndian))
                
                // Align device epoch (2000-01-01) with Unix epoch (1970-01-01)
                // Note: Matching Android implementation exactly
                let epochMillis = (secs + (RTC_BASE_OFFSET - 946_684_800)) * 1_000 + ms
                
                let date = Date(milliseconds: epochMillis)
                dateStr = DATE_FMT.string(from: date)            // yyyy-MM-dd (UTC)
                timeStr = TIME_FMT.string(from: date)            // HH:mm:ss.SSS (UTC)
            }
            
            let imuData = IMUData(
                count: count,
                accelX: accelX,
                accelY: accelY,
                accelZ: accelZ,
                gyroX: gyroX,
                gyroY: gyroY,
                gyroZ: gyroZ,
                adcRaw: adcRaw,
                date: dateStr,
                timeMs: timeStr
            )
            
            // print("ImuDataRspHandler - imuData: \(imuData)")
            
            handler.getCallBackToCentral()?.onImuDataRsp(imuData: imuData, handler: handler)
        } catch {
            print("ImuDataRspHandler - Error parsing data: \(error)")
        }
    }
}

