//
//  BleStateMethod.swift
//  Runner
//
//  Created by MAC on 12/3/25.
//

import Foundation

/// Make sure the method value matches the `BleStateMethod` on the Flutter side
enum BleStateMethod: String {
    case isBleEnabled = "isBleEnabled"
    case enableBle = "enableBle"
}
