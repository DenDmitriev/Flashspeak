//
//  UIImageExtension.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 12.05.2023.
//

import UIKit

extension UIImage {
    
    func roundedImage(cornerRadius: CGFloat) -> UIImage? {
        let size = self.size
        
        // create image layer
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageLayer.contents = self.cgImage
        
        // set radius
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = cornerRadius
        
        // get rounded image
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            imageLayer.render(in: context)
        }
        let roundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundImage
    }
}

