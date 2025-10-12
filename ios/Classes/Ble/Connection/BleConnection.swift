//
//  BleConnection.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import Foundation
import CoreBluetooth

class BleConnection: NSObject, CBPeripheralDelegate, BleCentralManagerToConnectionCallback {

    private var isEnableBle = false
    private var centralTxCharacteristic: CBCharacteristic?
    private var centralRxCharacteristic: CBCharacteristic?
    private var device: CBPeripheral?
    private var central: BleCentralManager?
    private var callbackToDevice: BleConnectionToDeviceCallback?
    
    init(peripheral: CBPeripheral, callback: BleConnectionToDeviceCallback, central: BleCentralManager) {
        super.init()
        self.callbackToDevice = callback
        self.device = peripheral
        self.central = central
        self.device?.delegate = self
    }
    
    func connect() {
        NSLog("[BleConnection - connect]")
        if(device != nil) {
            central?.connect(peripheral: device!)
        }
    }
    
    // device auto disconnect by any reason (Bluetooth, device issue,...) -> only change status
    func changeDisconnectStatus() {
        if(device != nil) {
            callbackToDevice?.onDisconnected(peripheral: device!)
        }
    }
    
    func requestToDisconnect() {
        if(device == nil) {
            return
        }
        callbackToDevice?.onDisconnected(peripheral: device!)
        self.centralRxCharacteristic = nil
        self.centralTxCharacteristic = nil
    }
    
    func write(data: Data) {
        NSLog("[BleConnection - write] data: \(data)")
        if (centralTxCharacteristic != nil) {
            self.device?.writeValue(data, for: centralTxCharacteristic!, type: .withoutResponse)
        }
    }
    
    //************************** CENTRAL EVENTS ********************************************************
    func onConnected(peripheral: CBPeripheral) {
        print("[BleConnection - onConnected]: \(peripheral.identifier.uuidString)")
        if (peripheral.identifier.uuidString == device?.identifier.uuidString) {
            peripheral.discoverServices(nil)
            callbackToDevice?.onConnected(peripheral: peripheral)
        }
    }
    
    func onDisconnect(peripheral: CBPeripheral) {
        NSLog("[BleConnection - onDisconnect]: \(peripheral.identifier.uuidString)")
        if (peripheral.identifier.uuidString == device?.identifier.uuidString) {
            callbackToDevice?.onDisconnected(peripheral: device!)
        }
    }
    
    //************************** PERIPHERAL EVENTS ********************************************************
    // Include discover service and characteristic

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if (error == nil) {
            if let services = peripheral.services {
                for service in services {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        discoverService(service: service, peripheral: peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil || characteristic.value == nil) {return}
        switch (characteristic.uuid) {
        case BleConstant.CENTRAL_RX_CHARACTERISTIC_UUID:
            NSLog("[BleConnection - Receive Data], data: \(String(describing: characteristic.value?.convertDataToHexString()))")
            callbackToDevice?.onDataReceived(peripheral: peripheral, data: characteristic.value!)
            break
        default:
            break
        }
    }
    
    private func discoverService(service: CBService, peripheral: CBPeripheral) {
        NSLog("[BleConnection - Discover service]: \(peripheral)")
        for charac in service.characteristics! {
            switch (charac.uuid) {
            case BleConstant.CENTRAL_RX_CHARACTERISTIC_UUID:
                NSLog("RX")
                centralRxCharacteristic = charac
                peripheral.setNotifyValue(true, for: charac)
                break
            case BleConstant.CENTRAL_TX_CHARACTERISTIC_UUID:
                NSLog("TX")
                centralTxCharacteristic = charac
                break
            default:
                break
                
            }
        }
    }
    //****************************************************************************************************************
}
