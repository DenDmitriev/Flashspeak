//
//  FlexProgressView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 23.05.2023.
//

import UIKit.UIProgressView

class FlexProgressView: UIProgressView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
    
}
