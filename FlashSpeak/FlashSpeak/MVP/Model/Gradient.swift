//
//  Gradient.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

enum Gradient {
    case red, green, yellow, violet, blue, grey
    
    ///Gradient layer
    var layer: CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = self.colors
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }
    
    private var colors: [CGColor] {
        switch self {
        case .red:
            return [
                UIColor(red: 0.85, green: 0.298, blue: 0.43, alpha: 1).cgColor,
                UIColor(red: 0.983, green: 0.553, blue: 0.553, alpha: 1).cgColor
            ]
        case .green:
            return [
                UIColor(red: 0.46, green: 0.633, blue: 0.354, alpha: 1).cgColor,
                UIColor(red: 0.595, green: 0.904, blue: 0.608, alpha: 1).cgColor
            ]
        case .yellow:
            return [
                UIColor(red: 0.929, green: 0.756, blue: 0.31, alpha: 1).cgColor,
                UIColor(red: 0.942, green: 0.895, blue: 0.647, alpha: 1).cgColor
            ]
        case .violet:
            return [
                UIColor(red: 0.589, green: 0.278, blue: 0.667, alpha: 1).cgColor,
                UIColor(red: 0.908, green: 0.624, blue: 0.88, alpha: 1).cgColor
            ]
        case .blue:
            return [
                UIColor(red: 0.257, green: 0.498, blue: 0.858, alpha: 1).cgColor,
                UIColor(red: 0.643, green: 0.769, blue: 0.958, alpha: 1).cgColor
            ]
        case .grey:
            return [
                UIColor(red: 0.654, green: 0.654, blue: 0.654, alpha: 1).cgColor,
                UIColor(red: 0.812, green: 0.812, blue: 0.812, alpha: 1).cgColor
            ]
        }
    }
}
