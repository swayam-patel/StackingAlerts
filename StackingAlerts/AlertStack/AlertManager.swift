//
//  AlertManager.swift
//  StackingAlerts
//
//  Created by Swayam Patel on 18/04/25.
//

import Foundation
import UIKit

// Custom Queue struct for managing alerts
struct Queue<T> {
    private var elements: [T] = []
    
    var isEmpty: Bool {
        elements.isEmpty
    }
    
    var count: Int {
        elements.count
    }
    
    var first: T? {
        elements.first
    }
    
    var last: T? {
        elements.last
    }
    
    mutating func enqueue(_ element: T, atFront: Bool = false) {
        if atFront {
            elements.insert(element, at: 0)
        } else {
            elements.append(element)
        }
    }
    
    mutating func dequeueFirst() -> T? {
        isEmpty ? nil : elements.removeFirst()
    }
    
    mutating func dequeueLast() -> T? {
        isEmpty ? nil : elements.removeLast()
    }
    
    func getElements() -> [T] {
        elements
    }
}

class AlertManager {
    static let shared = AlertManager()
    private var alerts = Queue<AlertView>()
    private let maxAlerts = 3
    private let topSpacing: CGFloat = 4
    private let bottomSpacing: CGFloat = 6
    private let animationDuration: TimeInterval = 0.4
    private let window = UIApplication.shared.windows.first!
    private let safeAreaTop = UIApplication.shared.windows.first!.safeAreaInsets.top
    private let safeAreaBottom = UIApplication.shared.windows.first!.safeAreaInsets.bottom
    private let alertHeight: CGFloat = 40
    
    private init() {}
    
    func showAlert(message: String, duration: TimeInterval = 3.0, fromTop: Bool) {
        
        // If stack is full, remove the oldest alert
        if alerts.count >= maxAlerts {
            let alertToRemove = fromTop ? alerts.last : alerts.first
            if let alertToRemove = alertToRemove {
                dismissAlert(alertToRemove, reposition: false, isFromTop: fromTop)
            }
        }
        
        // Create and configure new alert
        let alert = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as! AlertView
        alert.messageLabel?.text = message
        alert.frame = CGRect(
            x: 10,
            y: fromTop ? -alertHeight : window.frame.height,
            width: window.frame.width - 20,
            height: alertHeight
        )
        alert.alpha = 0
        
        // Enqueue alert
        alerts.enqueue(alert, atFront: fromTop)
        
        // Perform UI updates on main thread
        DispatchQueue.main.async {
            self.window.addSubview(alert)
            self.repositionAlerts(isFromTop: fromTop)
        }
        
        // Schedule dismissal
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.dismissAlert(alert, isFromTop: fromTop)
        }
    }
    
    private func dismissAlert(_ alert: AlertView, reposition: Bool = true, isFromTop: Bool) {
        // Check if alert is in the queue
        let alertExists = alerts.getElements().contains { $0 == alert }
        guard alertExists else { return }
        
        // Determine if alert is first or last and dequeue accordingly
        if alert == alerts.first {
            _ = alerts.dequeueFirst()
        } else if alert == alerts.last {
            _ = alerts.dequeueLast()
        } else {
            // If not first or last, skip dequeue to avoid inconsistent state
            return
        }
        
        // Animate out on main thread
        DispatchQueue.main.async { [self] in
            let dismissY = isFromTop ? -alertHeight : window.frame.height
            
            UIView.animate(withDuration: animationDuration, animations: {
                alert.frame.origin.y = dismissY
                alert.alpha = 0
            }) { _ in
                alert.removeFromSuperview()
                if reposition {
                    self.repositionAlerts(isFromTop: isFromTop)
                }
            }
        }
    }
    
    private func repositionAlerts(isFromTop: Bool) {
        let alertElements = alerts.getElements()
        
        // Animate alerts to new positions on main thread
        DispatchQueue.main.async { [self] in
            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut) { [self] in
                for (index, alert) in alertElements.enumerated() {
                    let spacing = isFromTop ? topSpacing : bottomSpacing
                    let targetY = isFromTop ?
                        safeAreaTop + CGFloat(index) * (alertHeight + spacing) : window.frame.height - alertHeight - bottomSpacing - CGFloat(alerts.count - 1 - index) * (alertHeight + bottomSpacing)
                    alert.frame.origin.y = targetY
                    alert.alpha = 1
                }
            }
        }
    }
}
