//
//  DeviceHandler.swift
//  Runner
//
//  Created by MAC on 11/3/25.
//

import Foundation
import CoreBluetooth

class DeviceHandler: DataParserCallback, BleConnectionToDeviceCallback {
  
    private var peripheral: BlePeripheral?
    private var callbackToCentral: DeviceHandlerToCentralCallback?
    private var parser: DataParser?
    
    init(peripheral: CBPeripheral, callback: DeviceHandlerToCentralCallback, central: BleCentralManager) {
        self.peripheral = BlePeripheral(peripheral: peripheral, callback: self, central: central)
        self.callbackToCentral = callback
        
        parser = DataParser(callback: self)
        parser?.start()
    }
    
    func getCallBackToCentral() -> DeviceHandlerToCentralCallback? {
        return callbackToCentral
    }
    
    func connect() {
        peripheral?.connect()
        
    }
    
    func getConnection() -> BleConnection? {
        peripheral?.getConnection()
    }
    
    func changeDisconnectStatus() {
        peripheral?.changeDisconnectStatus()
    }
    
    func requestToDisconnect() {
        peripheral?.requestToDisconnect()
        parser?.stop()
    }
    
    func write(data: Data) {
        peripheral?.write(data: data)
    }
    
    func getDevice() -> BlePeripheral? {
         return peripheral
    }
    
    func getCBPeripheral() -> CBPeripheral? {
        return peripheral?.getDevice()
    }
    
    //************************** DATA PARSER CALLBACK *************************************************
    
    func onPacketRecieved(packet: Packet) {
        ReceiveDataHandler.handle(packet: packet, handler: self)
    }
    
    //************************** BLE CONNECTION CALLBACK **********************************************
    
    func onConnected(peripheral: CBPeripheral) {
        callbackToCentral?.onConnected(handler: self)
    }
    
    func onDisconnected(peripheral: CBPeripheral) {
        callbackToCentral?.onDisConnected(handler: self)
    }
    
    func onDataReceived(peripheral: CBPeripheral, data: Data) {
        parser?.push(data: data)
    }
    
    //*************************************************************************************************
}
