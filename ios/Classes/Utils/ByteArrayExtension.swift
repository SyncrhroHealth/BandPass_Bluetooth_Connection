//
//  Untitled.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

extension Array where Element == UInt8 {
    /// Converts byte array to hex string representation
    func toHexString() -> String {
        return self.map { String(format: "%02X", $0) }.joined(separator: " ")
    }
}
