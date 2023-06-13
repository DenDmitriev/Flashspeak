//
//  ColorCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    static let identifier = "ColorCell"
    
    var style: GradientStyle = .grey
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer.gradientLayer(for: style, in: contentView.frame)
        layer.borderColor = UIColor.tint.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupStyle()
    }
    
    func configure(style: GradientStyle) {
        self.style = style
    }
    
    override var isSelected: Bool {
        willSet {
            super.isSelected = newValue
            if newValue {
                gradientLayer.borderWidth = Grid.pt4
            } else {
                gradientLayer.borderWidth = .zero
            }
        }
    }
    
    private func setupStyle() {
        gradientLayer.cornerRadius = Grid.cr4
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
