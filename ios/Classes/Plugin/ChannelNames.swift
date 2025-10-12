//
//  Untitled.swift
//  Runner
//
//  Created by MAC on 12/3/25.
//

import Foundation

/// Make sure this class matches the `ChannelNames` on the Flutter side
struct ChannelNames {
    // PREFIX
    private static let CHANNEL_PREFIX = "com.flutter.plugin"

    private static let METHOD = "method"
    private static let EVENT = "event"

    static let DEVICE_CORE_METHOD_CHANNEL = "\(CHANNEL_PREFIX)/\(METHOD)/device"
    static let DEVICE_CORE_EVENT_CHANNEL = "\(CHANNEL_PREFIX)/\(EVENT)/device"

    static let BLE_STATE_METHOD_CHANNEL = "\(CHANNEL_PREFIX)/\(METHOD)/bluetooth_state"
    static let BLE_STATE_EVENT_CHANNEL = "\(CHANNEL_PREFIX)/\(EVENT)/bluetooth_state"
}
