//
//  LearnProgressView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 11.05.2023.
//

import UIKit

class LearnProgressView: UIProgressView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
    
}
