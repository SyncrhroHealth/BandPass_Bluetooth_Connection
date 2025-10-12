//
//  BleConnectionToDeviceCallback.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import Foundation
import CoreBluetooth

protocol BleConnectionToDeviceCallback {
    func onConnected(peripheral: CBPeripheral)
    func onDisconnected(peripheral: CBPeripheral)
    func onDataReceived(peripheral: CBPeripheral, data: Data)
}
