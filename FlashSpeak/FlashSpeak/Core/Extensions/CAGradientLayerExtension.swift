//
//  CAGradientLayerExtension.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.04.2023.
//

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
            beginColor = #colorLiteral(red: 0.9568627451, green: 0.6117647059, blue: 0.3607843137, alpha: 1)
            endColor = #colorLiteral(red: 0.9490196078, green: 0.8039215686, blue: 0.7019607843, alpha: 1)
        case .green:
            beginColor = #colorLiteral(red: 0.4588235294, green: 0.631372549, blue: 0.3529411765, alpha: 1)
            endColor = #colorLiteral(red: 0.5960784314, green: 0.9058823529, blue: 0.6078431373, alpha: 1)
        case .yellow:
            beginColor = #colorLiteral(red: 0.9294117647, green: 0.7568627451, blue: 0.3098039216, alpha: 1)
            endColor = #colorLiteral(red: 0.9411764706, green: 0.8941176471, blue: 0.6470588235, alpha: 1)
        case .violet:
            beginColor = #colorLiteral(red: 0.5882352941, green: 0.2784313725, blue: 0.6666666667, alpha: 1)
            endColor = #colorLiteral(red: 0.9098039216, green: 0.6235294118, blue: 0.8784313725, alpha: 1)
        case .blue:
            beginColor = #colorLiteral(red: 0.2588235294, green: 0.4980392157, blue: 0.8588235294, alpha: 1)
            endColor = #colorLiteral(red: 0.6431372549, green: 0.768627451, blue: 0.9568627451, alpha: 1)
        case .grey:
            beginColor = #colorLiteral(red: 0.6549019608, green: 0.6549019608, blue: 0.6549019608, alpha: 1)
            endColor = #colorLiteral(red: 0.8117647059, green: 0.8117647059, blue: 0.8117647059, alpha: 1)
        }
        
        return [beginColor.cgColor, endColor.cgColor]
    }
}
