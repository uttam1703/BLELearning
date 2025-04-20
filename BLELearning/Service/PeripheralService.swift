//
//  PeripheralManager.swift
//  BLELearning
//
//  Created by uttamkumar bala on 09/04/25.
//

import Foundation
import CoreBluetooth

final class PeripheralService: NSObject, BLEService {
    
    var getMessage: ((String) -> Void)?
    
    private var peripheralManager: CBPeripheralManager!
    private var peripheralManagerCharacteristics: CBMutableCharacteristic?
    var characteristicUUID: CBUUID  {
        return CBUUID(string: Constant.uuidString)
    }
    
    var serviceUUID: CBUUID {
        return CBUUID(string: Constant.serviceUUIDString)
    }
    
    override init() {
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    private func startAdvertising() {
        print("Start Advertising")
        let characteristics = CBMutableCharacteristic(type: characteristicUUID,
                                                      properties: [.write, .notify],
                                                      value: nil,
                                                      permissions: .writeable)
        self.peripheralManagerCharacteristics = characteristics
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [characteristics]
        peripheralManager.add(service)
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [service.uuid]])
    }
    
    private func writeValuesToCentral(message: String) {
        guard let data = message.data(using: .utf8),
              let characteristics = peripheralManagerCharacteristics else { return }
        
        peripheralManager.updateValue(data, for: characteristics, onSubscribedCentrals: nil)
    }
    
    func write(with message: String) {
        writeValuesToCentral(message: message)
    }
}

extension PeripheralService: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard peripheral.state == .poweredOn else { return }
        startAdvertising()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        guard let request = requests.first,
              let data = request.value else { return }
        
        let message = String(decoding: data, as: UTF8.self)
        print("Message from central: \(message)")
        getMessage?(message)
    }
}
