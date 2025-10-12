//
//  BleCentralManager.swift
//  Runner
//
//  Created by Vo Khac Tuyen on 9/3/25.
//

import Foundation
import RxSwift
import CoreBluetooth

class BleCentralManager: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate, DeviceHandlerToCentralCallback {
    
    //************************** DEVICE HANDLER CALLBACK ****************************************************
    //************************** SEND EVENT TO CORE HANDLER *************************************************
    
    func onConnected(handler: DeviceHandler) {
        bleCentralManagerToCoreCallback?.onConnected(handler: handler)
    }
    
    func onDisConnected(handler: DeviceHandler) {
        bleCentralManagerToCoreCallback?.onDisConnected(handler: handler)
    }

    func onDeviceNameRsp(deviceName: String, handler: DeviceHandler) {
        bleCentralManagerToCoreCallback?.onDeviceNameRsp(deviceName: deviceName, handler: handler)
    }

    func onDeviceInfoRsp(deviceInfo: DeviceInfo, handler: DeviceHandler) {
        bleCentralManagerToCoreCallback?.onDeviceInfoRsp(deviceInfo: deviceInfo, handler: handler)
    }

    func onBasicInfoRsp(basicInfo: BasicInfo, handler: DeviceHandler) {
        bleCentralManagerToCoreCallback?.onBasicInfoRsp(basicInfo: basicInfo, handler: handler)
    }

    func onHotBoxDataRsp(hotBoxData: HotBoxData, handler: DeviceHandler) {
        bleCentralManagerToCoreCallback?.onHotBoxDataRsp(hotBoxData: hotBoxData, handler: handler)
    }

    func onTimeStampRsp(timeStamp: TimeStamp, handler: DeviceHandler) {
        bleCentralManagerToCoreCallback?.onTimeStampRsp(timeStamp: timeStamp, handler: handler)
    }

    func onScheduleRsp(schedule: Schedule, handler: DeviceHandler) {
        bleCentralManagerToCoreCallback?.onScheduleRsp(schedule: schedule, handler: handler)
    }
    
    func onHeaterTuningRsp(heaterTuning: HeaterTuning, handler: DeviceHandler) {
        bleCentralManagerToCoreCallback?.onHeaterTuningRsp(heaterTuning: heaterTuning, handler: handler)
    }
    
    let restoreKey = "get.myId.centralManagerRestoreKey"
    
    static let shared = BleCentralManager()
    
    private var centralManager: CBCentralManager?
    
    private var scanToCoreHandlerCallback: BleScannerCallback?
    private var bleCentralManagerToCoreCallback: BleCentralManagerToCoreCallback?
    
    var isEnableBle = false
    var shouldStartScan = false
    
    private var scanDeviceList: [CBPeripheral] = []
    private var connectedDevices: [DeviceHandler] = []
    
    // use for reconnect device
    var disposableScan: Disposable?
    private var scanObservers: (AnyObserver<CBPeripheral>)?
    var reconnectList : [String] = []
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey:restoreKey])
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        /// List peripherals restored
        let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral]
        NSLog("[WILL RESTORE STATE]: ")
        self.centralManager = central
        
        peripherals?.forEach{
            self.scanDeviceList.append($0)
            self.reconnectList.append($0.identifier.uuidString)
        }
    }
    
    func setCoreHandlerCallback(callback: BleCentralManagerToCoreCallback) {
        self.bleCentralManagerToCoreCallback = callback
    }
    
    func setScanCallback(callback: BleScannerCallback) {
        scanToCoreHandlerCallback = callback
    }
    
    func getDevice(address: String) -> DeviceHandler? {
        let handler = connectedDevices.first {$0.getDevice()?.getAddress() == address}
        return handler
    }
    
    func changeDisconnectStatus() {
        for handler in connectedDevices {
            handler.changeDisconnectStatus()
        }
    }
    
    //************************** RECONNECT ********************************************************
    
    func requestToReconnect(listAddress: [String]) {
        NSLog("request reconnect: \(listAddress)")
        
        if(!self.reconnectList.isEmpty && !self.scanDeviceList.isEmpty) {
            self.reconnectList.forEach{
                print("Trying to reconnecting... \($0)")
                CoreHandler.shared.connect(address: $0)
            }
            self.reconnectList.removeAll()
            return
        }
        self.reconnectList = listAddress
        stopScan()
        self.disposableScan?.dispose()
        self.disposableScan = startScanToReconnect()?
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] device in
                guard let self = self else { return }
                let uuidString = device.identifier.uuidString
                if self.reconnectList.contains(uuidString) {
                    print("Trying to reconnecting... \(uuidString)")
                    CoreHandler.shared.connect(address: uuidString)
                    // remove item in reconnectList if has scan found device
                    if let index = self.reconnectList.firstIndex(of: uuidString) {
                        self.reconnectList.remove(at: index)
                    }
                }
                
                if self.reconnectList.isEmpty {
                    self.stopScan()
                    self.disposableScan?.dispose()
                }
            }, onError: {error in
                self.disposableScan?.dispose()
            })
    }
    
    func startScanToReconnect() -> Observable<CBPeripheral>? {
        return Observable<CBPeripheral>.create{(observer) in
            self.scanDeviceList.removeAll()
            self.scanObservers = observer
            self.startScan()
            return Disposables.create()
        }
    }
    
    func updateNext(peripheral: CBPeripheral) {
        scanObservers?.onNext(peripheral)
    }
    
    
    //************************** CONNECT EVENTS ****************************************************
    func connect(peripheral: CBPeripheral) {
        centralManager?.connect(peripheral)
    }
    
    func connect(address: String) {
        let device = getScanPeripheral(address: address)
        if (device != nil) {
            var handler = connectedDevices.first { $0.getDevice()?.getAddress() == address }
            if(handler == nil) {
                handler = DeviceHandler(peripheral: device!, callback: self, central: self)
                connectedDevices.append(handler!)
            }
            
            handler?.connect()
        }
    }
    
    func requestToDisconnect(address: String) {
        let index = connectedDevices.firstIndex { $0.getDevice()?.getAddress() == address}
        if(index == nil) {
            return
        }
        
        NSLog("index: \(String(describing: index))")
        
        let handler = connectedDevices[index!]
        handler.requestToDisconnect()
        centralManager?.cancelPeripheralConnection(handler.getCBPeripheral()!)
        connectedDevices.remove(at: index!)
    }
    
    //************************** SCAN EVENTS ****************************************************
    
    func startScan() {
        shouldStartScan = true
        if (isEnableBle) {
            shouldStartScan = false
            scanDeviceList.removeAll()
            centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func stopScan() {
        shouldStartScan = false
        centralManager?.stopScan()
    }
    
    func getScanPeripheral(address: String) -> CBPeripheral? {
        for i in 0..<scanDeviceList.count {
            if (scanDeviceList[i].identifier.uuidString == address) {
                NSLog("getScanPeripheral \(address) exist")
                return scanDeviceList[i]
            }
        }
        NSLog("getScanPeripheral \(address) nil")
        return nil
    }
    
    //************************** CENTRAL MANAGER EVENTS CALLBACK ****************************************************
    
    // BLE STATE
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let isEnable = central.state == CBManagerState.poweredOn
        NSLog("[BleCentralManager - centralManagerDidUpdateState]: \(central) isEnable: \(isEnable)")
        FileLogger.log("[BleCEntralManager] - centralManagerDidUpdateState: isEnable: \(isEnable)")
        self.isEnableBle = isEnable
        
        // reconnect when bluetooth is turn on
        if(isEnable) {
            self.reconnectList.forEach{
                NSLog("[trying to connect]: \($0)")
                CoreHandler.shared.connect(address: $0)
            }
        }
        
        // start scan again when bluetooth is turn on
        if (shouldStartScan && isEnable) {
            startScan()
        }
        
        // update bluetooth status on-off
        scanToCoreHandlerCallback?.onBleState(enable: isEnable)
    }
    
    func reconnectAll() {
        self.connectedDevices.forEach{
            let peripheral = $0.getCBPeripheral()
            if(peripheral == nil) {
                return
            }
            centralManager?.connect(peripheral!)
        }
    }
    
    //************************** ON DEVICE FOUND CALLBACK ****************************************************
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let deviceName = peripheral.name
        if (deviceName == nil || !deviceName!.starts(with: BleConstant.PREFIX_HOT_BOX)) {
            return
        }
        let existPeripheral = getScanPeripheral(address: peripheral.identifier.uuidString)
        
        NSLog("[RECEIVE DEVICE]:  existed: \(String(describing: existPeripheral?.identifier.uuidString))")
        
        if (existPeripheral == nil) {
            scanDeviceList.append(peripheral)
            updateNext(peripheral: peripheral)
            scanToCoreHandlerCallback?.onFoundDevice(peripheral: peripheral, rssi: RSSI)
        }
    }
    
    //************************** ON DEVICE FAIL TO CONNECT CALLBACK ****************************************************
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        NSLog("[BleCentralManager - didFailToConnect]:  existed: \(String(describing: peripheral.identifier.uuidString))")
//        FileLogger.log("[BleCEntralManager] - didFailToConnect: \(String(describing: peripheral.identifier.uuidString))")
        self.connectedDevices.forEach{
            $0.getConnection()?.onDisconnect(peripheral: peripheral)
        }
    }
    
    //************************** ON DEVICE CONNECTED CALLBACK ****************************************************
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("[centralManager - onConnected] peripheral: \(peripheral.identifier.uuidString)")
//        FileLogger.log("[BleCEntralManager] - didConnect: \(peripheral.identifier.uuidString)")
        self.connectedDevices.forEach{
            $0.getConnection()?.onConnected(peripheral: peripheral)
        }
    }
    
    //************************** ON DEVICE DISCONNECT PERIPHERAL CALLBACK ****************************************************
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        NSLog("[centralManager - didDisconnectPeripheral]: \(peripheral.identifier.uuidString)")
//        FileLogger.log("[BleCEntralManager] - didDisconnectPeripheral: \(peripheral.identifier.uuidString)")
        self.connectedDevices.forEach{
            $0.getConnection()?.onDisconnect(peripheral: peripheral)
        }
        // peripheral not exist in connectedDevices
        // -> that's mean that peripheral has been request to disconnect
        if(!connectedDevices.contains(where: { $0.getDevice()?.getAddress() == peripheral.identifier.uuidString })){
            return
        }
        
        // trying to reconnect peripheral
        NSLog("start reconnecting: \(peripheral.identifier.uuidString)")
        centralManager?.connect(peripheral)
    }
}
