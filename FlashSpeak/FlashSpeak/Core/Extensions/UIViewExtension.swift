//
//  UIViewExtension.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 23.04.2023.
//

import UIKit

extension UIView {
    func addDashedBorder(
        color: UIColor,
        width: CGFloat = 1,
        dashPattern: [NSNumber] = [3, 6],
        cornerRadius: CGFloat = 0
    ) {
        let shapeLayer = CAShapeLayer()
        let shapeBounds = CGRect(
            x: width / 2,
            y: width / 2,
            width: bounds.width - width,
            height: bounds.height - width
        )
        shapeLayer.bounds = shapeBounds
        shapeLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = dashPattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeBounds, cornerRadius: cornerRadius).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}
