//
//  UIColorExtension.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//
// swiftlint:disable discouraged_object_literal

import UIKit

extension UIColor {
    
    static var tint: UIColor { .systemBlue }
    
    static var backgroundWhite: UIColor { #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) }
    
    static var backgroundLightGray: UIColor { #colorLiteral(red: 0.96, green: 0.9599774584, blue: 0.9599774584, alpha: 1) }
    
    static var backgroundGray: UIColor { #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
    
    static var tabBarUnselected: UIColor { #colorLiteral(red: 0.8352, green: 0.85666, blue: 0.87, alpha: 1) }
    
    static var trueColor: UIColor { #colorLiteral(red: 0.7614505291, green: 0.9355570674, blue: 0.7498562336, alpha: 1) }
    
    static var falseColor: UIColor { #colorLiteral(red: 1, green: 0.7666072249, blue: 0.7605005503, alpha: 1) }
    
    static var textWhite: UIColor { #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) }
    
    static func color(by style: GradientStyle) -> UIColor? {
        switch style {
        case .red:
            return #colorLiteral(red: 0.8881066442, green: 0.3943773508, blue: 0.5057283044, alpha: 1)
        case .orange:
            return #colorLiteral(red: 0.8509803922, green: 0.4980392157, blue: 0.2980392157, alpha: 1)
        case .green:
            return #colorLiteral(red: 0.3803921569, green: 0.6823529412, blue: 0.3294117647, alpha: 1)
        case .yellow:
            return #colorLiteral(red: 0.8509803922, green: 0.6941176471, blue: 0.2980392157, alpha: 1)
        case .violet:
            return #colorLiteral(red: 0.4823529412, green: 0.2980392157, blue: 0.8509803922, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0.262745098, green: 0.6039215686, blue: 0.7490196078, alpha: 1)
        case .grey:
            return #colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1)
        }
    }
}

// swiftlint:enable discouraged_object_literal
