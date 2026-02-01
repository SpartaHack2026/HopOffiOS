//
//  UIView+Gradient.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//
import UIKit

extension UIView {
    func applyAppGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.gradientStart.cgColor,
            UIColor.gradientEnd.cgColor
        ]

        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint   = CGPoint(x: 1, y: 1)
        gradient.frame = bounds
        gradient.name = "AppGradient"

        // Remove existing gradient if reapplying
        layer.sublayers?
            .filter { $0.name == "AppGradient" }
            .forEach { $0.removeFromSuperlayer() }

        layer.insertSublayer(gradient, at: 0)
    }
    
    func updateAppGradientFrame() {
        let name = "AppGradientLayer"
        guard let gradient = layer.sublayers?.first(where: { $0.name == name }) as? CAGradientLayer else { return }
        gradient.frame = bounds
    }

}
