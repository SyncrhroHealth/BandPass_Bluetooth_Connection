//
//  NumberExt.swift
//  Runner
//
//  Created by MAC on 13/3/25.
//
import Foundation

public extension Float {
    /// Converts a `Float` to a 4-byte little-endian `UInt8` array
    func toLittleEndianBytes() -> [UInt8] {
        var value = self.bitPattern.littleEndian
        return withUnsafeBytes(of: &value) { Array($0) }
    }
}

public extension Int {
    /// Converts a `UInt16` integer to a 2-byte little-endian `UInt8` array
    func toLittleEndianBytes() -> [UInt8] {
        var value = UInt16(self).littleEndian
        return withUnsafeBytes(of: &value) { Array($0) }
    }
}

public extension Int64 {
    /// Converts an `Int64` to an 8-byte little-endian `UInt8` array
    func toLittleEndianBytes() -> [UInt8] {
        var value = self.littleEndian
        return withUnsafeBytes(of: &value) { Array($0) }
    }
}
