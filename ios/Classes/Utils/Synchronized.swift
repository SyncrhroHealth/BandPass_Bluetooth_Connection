//
//  Synchronized.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 8/3/25.
//

import Foundation

func synchronized<T>(_ lock: AnyObject, closure: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer {
        objc_sync_exit(lock)
    }
    return try closure()
}
