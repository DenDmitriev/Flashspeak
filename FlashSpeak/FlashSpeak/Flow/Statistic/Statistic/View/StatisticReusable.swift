//
//  StatisticReusable.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//

import UIKit

class StatisticReusable: UICollectionReusableView {
    
    // MARK: - Properites
    
    static var Identifier: String = "StatisticHeader"
    
    // MARK: - Subviews
    
    var label: UILabel = {
        let label: UILabel = UILabel()
        label.font = .title2
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Constractions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
