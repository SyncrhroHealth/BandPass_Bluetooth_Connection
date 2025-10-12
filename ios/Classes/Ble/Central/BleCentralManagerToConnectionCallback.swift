//
//  BleCentralManagerToConnectionCallback.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import Foundation
import CoreBluetooth

protocol BleCentralManagerToConnectionCallback: NSObject {
    func onConnected(peripheral: CBPeripheral)
    func onDisconnect(peripheral: CBPeripheral)
}
