//
//  DataParser.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 8/3/25.
//

import Foundation

class DataParser {
    var callback: DataParserCallback?
    
    var stopParser = false
    var thread: Thread?
    
    var buffer = BlockingQueue<Data>()
    
    
    init(callback: DataParserCallback) {
        self.callback = callback
    }
    
    func stop() {
        stopParser = true
        thread?.cancel()
        buffer.removeAll()
        thread = nil
    }
    
    func start() {
        thread = Thread.init(target: self, selector: #selector(longParserRunningProcess), object: nil)
        thread?.start()
    }
    
    @objc private func longParserRunningProcess() {
        while(!self.stopParser) {
            let data = try? self.buffer.take()
            if let data = data {
                self.parse(data: data)
            }
        }
    }
    
    func push(data: Data) {
        buffer.add(data)
    }
    
    
    private func parse(data: Data) {
        // Read the header from the data
        guard let header = readHeader(from: data) else {
            return
        }
        
        // Only proceed if the header’s command (cmd) is not nil
        if header.commandCode != nil {
            // Read the payload (data portion) of the packet
            guard let payload = readData(from: data) else {
                return
            }
            
            // Call the callback with a Packet constructed from the header and payload
            callback?.onPacketRecieved(packet: Packet(header: header, data: payload))
        }
    }
    
    
    /** Packet structure:
     *
     * Header (4 bytes): CMD(1 byte) , LEN(1 byte) , MSG_INDEX(2 bytes)
     * DATA (256 bytes)
     *
     */
    
    /** Header is from pos 0 to 4  of packet
     * Header.HEADER_SIZE = 4
     * */
    private func readHeader(from bytesPacket: Data) -> Header? {
        // Ensure data is at least 4 bytes
        guard bytesPacket.count >= Header.HEADER_SIZE else {
            print("Error: Packet too short for header")
            return nil
        }

        // Extract header safely
        let headerData = bytesPacket.subdata(in: 0..<Header.HEADER_SIZE)
        let cmd = CommandCode.fromValue(headerData[0]) // Safe access
        let len = Int(headerData[1])
        let msgIndex = Int(headerData[2]) | (Int(headerData[3]) << 8)

        return Header(commandCode: cmd, length: len, msgIndex: msgIndex)
    }


    /** Data is from pos 4 to length of packet
     * Header.HEADER_SIZE = 4
     * */
    private func readData(from bytesPacket: Data) -> Data? {
        guard bytesPacket.count > Header.HEADER_SIZE else {
            print("Error: Packet too short for data")
            return nil
        }
        return bytesPacket.subdata(in: Header.HEADER_SIZE..<bytesPacket.count)
    }

    
}
