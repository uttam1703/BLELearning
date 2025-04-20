//
//  BLEService.swift
//  BLELearning
//
//  Created by uttamkumar bala on 09/04/25.
//

import Foundation

protocol BLEService: NSObject {
    func write(with message: String)
    var getMessage: ((String) -> Void)? { get set }
}
