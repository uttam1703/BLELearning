//
//  BLECentralService.swift
//  BLELearning
//
//  Created by uttamkumar bala on 09/04/25.
//

import Foundation
import CoreBluetooth

final class BLECentralService: NSObject, BLEService {
    
    var getMessage: ((String) -> Void)? = nil
    
    var centralManager: CBCentralManager!
    private var peripheralToConnect: CBPeripheral?
    private var connectedPeripheral: CBPeripheral?
    private var discoveredCharacteristics: CBCharacteristic?
    var characteristicUUID: CBUUID  {
        CBUUID(string: Constant.uuidString)
    }
    
    var sericeUUID: CBUUID {
        CBUUID(string: Constant.serviceUUIDString)
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private func startScan() {
        print("start scan")
        let service = sericeUUID
        peripheralToConnect = nil
        centralManager.scanForPeripherals(withServices: [service])
    }
    

    
  
    
    private func writeValuesToPeripheral(message: String) {
        guard let connectedPeripheral = connectedPeripheral,
              let discoveredCharacteristics,
              let data = message.data(using: .utf8)
        else { return }
        
        connectedPeripheral.writeValue(data, for: discoveredCharacteristics, type: .withResponse)
    }
    
    func write(with message: String) {
        writeValuesToPeripheral(message: message)
    }
}

extension BLECentralService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else { return }
        print("centralManagerDidUpdateState - powerOn")
        startScan()
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("didDiscover - \(peripheral.name ?? "nil")")
        peripheralToConnect = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect: \(peripheral.name ?? "")")
        centralManager.stopScan()
        let service = sericeUUID
        connectedPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices([service])
    }
}

extension BLECentralService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        if let error = error {
            print("ERROR : didDiscoverServices - \(error.localizedDescription)")
            return
        }
        print("didDiscoverServices : \(peripheral.name ?? "nil")")
//        let characteristic = CBUUID(string: uuidString)
        peripheral.services?.forEach({ service in
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        })
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if let error = error {
            print("ERROR: didDiscoverCharacteristicsFor - \(peripheral.name ?? "")")
            return
        }
        
//        let characteristicUUID = CBUUID(string: uuidString)
        service.characteristics?.forEach({ characteristic in
            guard characteristicUUID == characteristic.uuid else { return }
            peripheral.setNotifyValue(true, for: characteristic)
            discoveredCharacteristics = characteristic
        })
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
        if let error {
            print("Error: didUpdateNotificationStateFor - \(peripheral.name ?? "")")
            return
        }
        
        guard characteristic.uuid == characteristicUUID else { return }
        
        if characteristic.isNotifying {
            print("Characteristic notifications have begun.")
        } else {
            print("Characteristic notifications have stopped. Disconnecting.")
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if let error {
            print("ERROR: Characteristic value update failed: \(error.localizedDescription)")
        }
        
        guard let data = characteristic.value else { return }
        let message = String(decoding: data, as: UTF8.self)
        
        getMessage?(message)
//        showMessage(message: message)
    }
}




