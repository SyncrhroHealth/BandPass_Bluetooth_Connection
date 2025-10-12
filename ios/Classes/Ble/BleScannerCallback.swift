//
//  BleScannerCallback.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import Foundation
import CoreBluetooth

protocol BleScannerCallback {
    func onBleState(enable: Bool)
    func onFoundDevice(peripheral: CBPeripheral, rssi: NSNumber)
}
