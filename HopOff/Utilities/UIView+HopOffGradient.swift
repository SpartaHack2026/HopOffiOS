//
//  UIView+HopOffGradient.swift
//  HopOff
//
//  Created by Edom Belayneh on 1/31/26.
//

import UIKit

extension UIView {
    func applyHopOffGradient(
        start: UIColor = .gradientStart,
        end: UIColor = .gradientEnd,
        startPoint: CGPoint = CGPoint(x: 0, y: 0),
        endPoint: CGPoint = CGPoint(x: 1, y: 1)
    ) {
        let name = "HopOffGradientLayer"

        // Remove existing gradient layer if present (avoids stacking layers)
        layer.sublayers?.removeAll(where: { $0.name == name })

        let gradient = CAGradientLayer()
        gradient.name = name
        gradient.colors = [start.cgColor, end.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = bounds

        layer.insertSublayer(gradient, at: 0)
    }

    func updateHopOffGradientFrame() {
        let name = "HopOffGradientLayer"
        guard let gradient = layer.sublayers?.first(where: { $0.name == name }) as? CAGradientLayer else { return }
        gradient.frame = bounds
    }
}

