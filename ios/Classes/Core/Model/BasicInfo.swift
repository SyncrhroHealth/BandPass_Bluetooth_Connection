//
//  BasicInfo.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation

struct BasicInfo {
    let isTempSensorAttached: Int
    let deviceOperationMode: Int
    let modeThermostatState: Int
    let modeManualState: Int
    let runState: Int
    let fuelLevel: Int
    
    let currentLevel: Int
    let expectedLevel: Int
    let currentTemp: Float
    let expectedTemp: Float
}
