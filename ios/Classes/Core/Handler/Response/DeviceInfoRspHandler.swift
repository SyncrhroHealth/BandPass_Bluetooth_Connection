//
//  DeviceInfoRspHandler.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation

/// Data format:
/// - `char fw_ver[3]`  ([0]: MAJOR; [1]: MINOR; [2]: PATCH; Example: 1.0.1)
/// - `char hw_ver[3]`  ([0]: MAJOR; [1]: MINOR; [2]: PATCH; Example: 1.0.1)
/// - `char mac_addr[6]`
/// - `char device_name[20]`
struct DeviceInfoRspHandler {
    static func handle(data: Data, handler: DeviceHandler) {
        print("DeviceInfoRspHandler - handle: len: \(data.count), data: \(data.toHexString())")

        guard data.count >= 32 else {
            print("DeviceInfoRspHandler - Error: Not enough data received")
            return
        }

        do {
            // Extract firmware version bytes
            let fwVerBytes = data.subdata(in: 0..<3)
            let hwVerBytes = data.subdata(in: 3..<6)
            let addressBytes = data.subdata(in: 6..<12)
            let deviceNameBytes = data.subdata(in: 12..<32)

            // Convert version bytes to string
            let fwVer = parseVersion(from: fwVerBytes)
            let hwVer = parseVersion(from: hwVerBytes)

            // Convert MAC address to hex string
            let macAddress = addressBytes.map { String(format: "%02X", $0) }.joined(separator: ":")

            // Convert device name bytes to string
            let deviceName = deviceNameBytes.toString()?.trimmingCharacters(in: .controlCharacters) ?? ""

            let deviceInfo = DeviceInfo(
                fwVersion: fwVer,
                hwVersion: hwVer,
                macAddress: macAddress,
                deviceName: deviceName
            )

            handler.getCallBackToCentral()?.onDeviceInfoRsp(deviceInfo: deviceInfo, handler: handler)
        } catch {
            print("DeviceInfoRspHandler - Error parsing data: \(error)")
        }
    }

    /// Parses a 3-byte version Data into a `MAJOR.MINOR.PATCH` string.
    private static func parseVersion(from data: Data) -> String {
        guard data.count == 3 else { return "0.0.0" }
        let versionNumbers = data.map { max(Int($0) - 48, 0) }
        return versionNumbers.map { "\($0)" }.joined(separator: ".")
    }
}
