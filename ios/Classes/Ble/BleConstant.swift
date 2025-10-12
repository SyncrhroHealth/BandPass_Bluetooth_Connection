//
//  BleConstant.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import Foundation
import CoreBluetooth

class BleConstant {
    static let SERVICE_UUID = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e".uppercased())
    
    // Receive command from device
    static let CENTRAL_TX_CHARACTERISTIC_UUID = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e".uppercased())

    // Transfer command to device
    static let CENTRAL_RX_CHARACTERISTIC_UUID = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e".uppercased())
        
    static let PREFIX_HOT_BOX = "HOT-BOX"
}
