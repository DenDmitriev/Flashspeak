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
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }
    
    private static func colors(for style: GradientStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        /// https://flatuicolors.com/palette/de
        switch style {
        case .red:
            beginColor = #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0.3529411765, alpha: 1)
            endColor = #colorLiteral(red: 0.9882352941, green: 0.3607843137, blue: 0.3960784314, alpha: 1)
        case .orange:
            beginColor = #colorLiteral(red: 0.9803921569, green: 0.5098039216, blue: 0.1921568627, alpha: 1)
            endColor = #colorLiteral(red: 0.9921568627, green: 0.5882352941, blue: 0.2666666667, alpha: 1)
        case .yellow:
            beginColor = #colorLiteral(red: 0.968627451, green: 0.7176470588, blue: 0.1921568627, alpha: 1)
            endColor = #colorLiteral(red: 0.9960784314, green: 0.8274509804, blue: 0.1882352941, alpha: 1)
        case .green:
            beginColor = #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1)
            endColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        case .violet:
            beginColor = #colorLiteral(red: 0.5333333333, green: 0.3294117647, blue: 0.8156862745, alpha: 1)
            endColor = #colorLiteral(red: 0.6470588235, green: 0.368627451, blue: 0.9176470588, alpha: 1)
        case .blue:
            beginColor = #colorLiteral(red: 0.2196078431, green: 0.4039215686, blue: 0.8392156863, alpha: 1)
            endColor = #colorLiteral(red: 0.2941176471, green: 0.4823529412, blue: 0.9254901961, alpha: 1)
        case .grey:
            beginColor = #colorLiteral(red: 0.2941176471, green: 0.3960784314, blue: 0.5176470588, alpha: 1)
            endColor = #colorLiteral(red: 0.4666666667, green: 0.5490196078, blue: 0.6392156863, alpha: 1)
        }
        
        return [beginColor.cgColor, endColor.cgColor]
    }
    
    static func darkColor(for style: GradientStyle) -> UIColor {
        return UIColor(cgColor: CAGradientLayer.colors(for: style).first ?? UIColor.gray.cgColor)
    }
    
    static func lightColor(for style: GradientStyle) -> UIColor {
        return UIColor(cgColor: CAGradientLayer.colors(for: style).first ?? UIColor.gray.cgColor)
    }
}

// swiftlint:enable discouraged_object_literal
