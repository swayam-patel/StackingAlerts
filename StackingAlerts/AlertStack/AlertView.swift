//
//  AlertView.swift
//  StackingAlerts
//
//  Created by Swayam Patel on 18/04/25.
//

import UIKit

class AlertView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    
    // Initialize with message
    init(message: String) {
        super.init(frame: .zero)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    
    // Configure the UI
    private func configure() {
        // Style the view
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }
}
