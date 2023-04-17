//
//  ChangeLangButtonView.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 17.04.2023.
//

import UIKit

final class ChangeLangButtonView: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc extension ChangeLangButtonView {
    
    func configure() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
