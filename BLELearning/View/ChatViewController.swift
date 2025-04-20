//
//  ChatViewController.swift
//  BLELearning
//
//  Created by uttamkumar bala on 09/04/25.
//

import UIKit

class ChatViewController: UIViewController {

    var service: BLEService!
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.textColor = .label
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.font = .systemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.label, for: .normal)
//        button.titleLabel?.textColor = .systemMint
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var currentMessage: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Waiting for message..."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        service.getMessage = { [weak self] message in
            guard let self = self else { return }
            self.updateMessage(message)
        }
        
        let mainStack = UIStackView(arrangedSubviews: [textField, sendButton, currentMessage])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.distribution = .fill
        
        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            sendButton.widthAnchor.constraint(equalToConstant: 100),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            textField.heightAnchor.constraint(equalToConstant: 40),
            currentMessage.heightAnchor.constraint(equalToConstant: 40),
            
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    

    @objc private func sendMessage() {
        guard let text = textField.text else { return }
        service.write(with: text)
        textField.text = ""
    }
    
    private func updateMessage(_ message: String) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            currentMessage.text = message
            
        }
    }
    
    
}
