//
//  ProfileButton.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.06.2023.
//

import UIKit

class ProfileButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var configuration: UIButton.Configuration = .plain()
        configuration.cornerStyle = .medium
        configuration.buttonSize = .small
        configuration.imagePlacement = .leading
        configuration.imagePadding = Grid.pt8
//        configuration.subtitle = NSLocalizedString("Profile", comment: "button")
        self.configuration = configuration
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.layer.cornerRadius = Grid.cr4
        self.imageView?.layer.masksToBounds = true
        self.imageView?.layer.borderWidth = Grid.pt2
        self.imageView?.layer.borderColor = UIColor.tintColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func update(by language: Language) {
        self.configurationUpdateHandler = { button in
            if let image = UIImage(named: language.code) {
                var configuration = button.configuration
                // let aspect = image.size.width / image.size.height
                let height = Grid.pt36
                let width = height // * aspect
                let imageSize = CGSize(width: width, height: height)
                configuration?.image = image.imageResized(to: imageSize)
                var container = AttributeContainer()
                container.font = .boldSystemFont(ofSize: 16)
                configuration?.attributedTitle = AttributedString(language.description, attributes: container)
                
                button.configuration = configuration
                button.imageView?.layer.cornerRadius = height / 2
            }
        }
    }
}
