//
//  DataParserCallback.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 8/3/25.
//

import Foundation

protocol DataParserCallback {
    func onPacketRecieved(packet: Packet)
}
