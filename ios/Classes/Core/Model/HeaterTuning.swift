//
//  HeaterTuning.swift
//  Runner
//
//  Created by MAC on 20/4/25.
//

import Foundation

struct HeaterTuning {
    var fanMax: UInt16
    var fanMin: UInt16
    var seaLevel: UInt16
    var pumpRateMax: Float
    var pumpRateMin: Float
    
    init(fanMax: UInt16, fanMin: UInt16, seaLevel: UInt16, pumpRateMax: Float, pumpRateMin: Float) {
        self.fanMax = fanMax
        self.fanMin = fanMin
        self.seaLevel = seaLevel
        self.pumpRateMax = pumpRateMax
        self.pumpRateMin = pumpRateMin
    }
}
