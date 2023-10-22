//
//  CustomDesign.swift
//  Baluchon
//
//  Created by François-Xavier on 21/10/2023.
//

import Foundation
import UIKit

class CustomDesign: UIView {
    
    static func createLinearGradientBackground(view: UIView,color: CGColor) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [color, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        view.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {
    
    func linearGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            UIColor(#colorLiteral(red: 1, green: 0.6823529412, blue: 0.5176470588, alpha: 1)).cgColor,
            UIColor(#colorLiteral(red: 1, green: 0.8352941176, blue: 0.4392156863, alpha: 1)).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradient, at: 0)
    }
}
