//
//  IMUData.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation

/**
 * One BLE IMU sample – field names & formats match the Python parser.
 *
 *  • Sensor values stay as `Float` so you can still do math/plots.
 *    (If you only need the prettified strings, change them to `String`.)
 *  • `adcRaw`, `date`, `timeMs` are nullable because the tags may be absent.
 */
struct IMUData {
    let count: Int
    
    let accelX: Float
    let accelY: Float
    let accelZ: Float
    
    let gyroX: Float
    let gyroY: Float
    let gyroZ: Float
    
    let adcRaw: Int
    
    /** `yyyy-MM-dd` in **UTC**; empty string if RTC tag missing            */
    let date: String
    
    /** `HH:mm:ss.SSS` in **UTC**; empty string if RTC tag missing           */
    let timeMs: String
}

