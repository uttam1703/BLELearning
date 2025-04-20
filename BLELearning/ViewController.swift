//
//  ViewController.swift
//  BLELearning
//
//  Created by uttamkumar bala on 09/04/25.
//

import UIKit
import Foundation

class ViewController: UIViewController {

  
    var service: BLEService!
    lazy var primaryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Primary (central)", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(navigateToCentral), for: .touchUpInside)
        return button
    }()
    
    lazy var secondaryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Secondary (peripheral)", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(navigateToPeripheral), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        let mainStack = UIStackView(arrangedSubviews: [primaryButton, secondaryButton])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .center
        mainStack.distribution = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            sendButton.widthAnchor.constraint(equalToConstant: 100),
            primaryButton.heightAnchor.constraint(equalToConstant: 40),
            secondaryButton.heightAnchor.constraint(equalToConstant: 40),
            
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func navigateToCentral() {
        goToChatVC(true)
    }
    
    @objc private func navigateToPeripheral() {
        goToChatVC(false)
    }
    
    private func goToChatVC(_ isCentral: Bool) {
        
        let vc = ChatViewController()
        vc.service = isCentral ? BLECentralService() : PeripheralService()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

