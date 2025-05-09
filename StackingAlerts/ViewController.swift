//
//  ViewController.swift
//  StackingAlerts
//
//  Created by Swayam Patel on 09/05/25.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Create two buttons
        let topButton = UIButton(type: .system)
        topButton.setTitle("Alert from Top", for: .normal)
        topButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        topButton.translatesAutoresizingMaskIntoConstraints = false
        topButton.addTarget(self, action: #selector(showTopAlert), for: .touchUpInside)
        
        let bottomButton = UIButton(type: .system)
        bottomButton.setTitle("Alert from Bottom", for: .normal)
        bottomButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.addTarget(self, action: #selector(showBottomAlert), for: .touchUpInside)
        
        // Stack view to arrange buttons vertically
        let stackView = UIStackView(arrangedSubviews: [topButton, bottomButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Constraints to center stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showTopAlert() {
        AlertManager.shared.showAlert(message: "Alert from Top \(Int.random(in: 1...100))", fromTop: true)
    }
    
    @objc func showBottomAlert() {
        AlertManager.shared.showAlert(message: "Alert from Bottom \(Int.random(in: 1...100))", fromTop: false)
    }
    
}
