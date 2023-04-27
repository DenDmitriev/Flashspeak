//
//  CAGradientLayerExtension.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.04.2023.
//
// swiftlint:disable discouraged_object_literal

import UIKit

extension CAGradientLayer {
    
    static func gradientLayer(for style: GradientStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }
    
    private static func colors(for style: GradientStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch style {
        case .red:
            beginColor = #colorLiteral(red: 0.8881066442, green: 0.3943773508, blue: 0.5057283044, alpha: 1)
            endColor = #colorLiteral(red: 0.9843137255, green: 0.5529411765, blue: 0.5529411765, alpha: 1)
        case .orange:
            beginColor = #colorLiteral(red: 0.8509803922, green: 0.4980392157, blue: 0.2980392157, alpha: 1)
            endColor = #colorLiteral(red: 0.9843137255, green: 0.8117647059, blue: 0.5529411765, alpha: 1)
        case .green:
            beginColor = #colorLiteral(red: 0.3803921569, green: 0.6823529412, blue: 0.3294117647, alpha: 1)
            endColor = #colorLiteral(red: 0.5960784314, green: 0.9176470588, blue: 0.6274509804, alpha: 1)
        case .yellow:
            beginColor = #colorLiteral(red: 0.8509803922, green: 0.6941176471, blue: 0.2980392157, alpha: 1)
            endColor = #colorLiteral(red: 0.9333333333, green: 0.8901960784, blue: 0.5764705882, alpha: 1)
        case .violet:
            beginColor = #colorLiteral(red: 0.4823529412, green: 0.2980392157, blue: 0.8509803922, alpha: 1)
            endColor = #colorLiteral(red: 0.7960784314, green: 0.5529411765, blue: 0.9843137255, alpha: 1)
        case .blue:
            beginColor = #colorLiteral(red: 0.262745098, green: 0.6039215686, blue: 0.7490196078, alpha: 1)
            endColor = #colorLiteral(red: 0.5176470588, green: 0.7058823529, blue: 0.9215686275, alpha: 1)
        case .grey:
            beginColor = #colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1)
            endColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        }
        
        return [beginColor.cgColor, endColor.cgColor]
    }
}

// swiftlint:enable discouraged_object_literal
