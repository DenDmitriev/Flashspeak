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
            beginColor = #colorLiteral(red: 1, green: 0.2549019608, blue: 0.4235294118, alpha: 1)
            endColor = #colorLiteral(red: 1, green: 0.2941176471, blue: 0.168627451, alpha: 1)
        case .orange:
            beginColor = #colorLiteral(red: 1, green: 0.3176470588, blue: 0.1843137255, alpha: 1)
            endColor = #colorLiteral(red: 0.9411764706, green: 0.5960784314, blue: 0.09803921569, alpha: 1)
        case .yellow:
            beginColor = #colorLiteral(red: 0.9490196078, green: 0.6, blue: 0.2901960784, alpha: 1)
            endColor = #colorLiteral(red: 0.9490196078, green: 0.7882352941, blue: 0.2980392157, alpha: 1)
        case .green:
            beginColor = #colorLiteral(red: 0.337254902, green: 0.6705882353, blue: 0.1843137255, alpha: 1)
            endColor = #colorLiteral(red: 0.6588235294, green: 0.8784313725, blue: 0.3882352941, alpha: 1)
        case .violet:
            beginColor = #colorLiteral(red: 0.431372549, green: 0.2823529412, blue: 0.6666666667, alpha: 1)
            endColor = #colorLiteral(red: 0.6156862745, green: 0.3137254902, blue: 0.7333333333, alpha: 1)
        case .blue:
            beginColor = #colorLiteral(red: 0, green: 0.5137254902, blue: 0.6901960784, alpha: 1)
            endColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.8588235294, alpha: 1)
        case .grey:
            beginColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            endColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        return [beginColor.cgColor, endColor.cgColor]
    }
    
    static func beginColor(for style: GradientStyle) -> UIColor {
        return UIColor(cgColor: CAGradientLayer.colors(for: style).first ?? UIColor.gray.cgColor)
    }
}

// swiftlint:enable discouraged_object_literal
