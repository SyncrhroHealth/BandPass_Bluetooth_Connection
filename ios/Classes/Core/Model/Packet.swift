//
//  BasicInfo.swift
//  Runner
//
//  Created by MAC on 10/3/25.
//

import Foundation

struct Header: Equatable, Hashable {
    let commandCode: CommandCode?
    let length: Int
    let msgIndex: Int

    static let HEADER_SIZE = 4
}

struct Packet: Equatable {
    let header: Header
    let data: Data // Changed from [UInt8] to Data

    static func == (lhs: Packet, rhs: Packet) -> Bool {
        return lhs.header == rhs.header && lhs.data == rhs.data
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(header)
        hasher.combine(data)
    }
}
