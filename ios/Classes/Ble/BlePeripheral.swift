//
//  BlePeripheral.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import Foundation
import CoreBluetooth


class BlePeripheral {
    private let connection: BleConnection
    private var device: CBPeripheral
    
    var batteryLevel: Int = 0
    var isCharging: Bool = false

    var hwVersion: String = ""
    var fwVersion: String = ""
    var model: String = ""
    var serialNumber: String = ""

    init(peripheral: CBPeripheral, callback: BleConnectionToDeviceCallback, central: BleCentralManager) {
        connection = BleConnection(peripheral: peripheral, callback: callback, central: central)
        device = peripheral
    }

    func connect() {
        connection.connect()
    }
    
    func getConnection() -> BleConnection {
        return connection
    }

    func requestToDisconnect() {
        connection.requestToDisconnect()
    }
    
    func changeDisconnectStatus() {
        connection.changeDisconnectStatus()
    }

    func write(data: Data) {
        connection.write(data: data)
    }

    func write(data: String) {
        
    }

    func getAddress() -> String {
        return device.identifier.uuidString;
    }

    func getName() -> String {
        return device.name ?? "";
    }
    
    func getDevice() -> CBPeripheral {
        return device
    }
}
