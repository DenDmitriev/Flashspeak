//
//  UIButtonConfigurationExtension.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//

import UIKit

extension UIButton.Configuration {
    public static func appFilled() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .large
        configuration.buttonSize = .medium
        configuration.titleTextAttributesTransformer = .init({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.title3
            return outgoing
        })
        return configuration
    }
    
    public static func appGray() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .large
        configuration.buttonSize = .medium
        configuration.titleTextAttributesTransformer = .init({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.title3
            return outgoing
        })
        return configuration
    }
    
    public static func appTinted() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.tinted()
        configuration.cornerStyle = .large
        configuration.buttonSize = .medium
        configuration.titleTextAttributesTransformer = .init({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.title3
            return outgoing
        })
        return configuration
    }
    
    public static func appFilledInvert() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .fiveBackgroundColor
        configuration.cornerStyle = .large
        configuration.buttonSize = .medium
        configuration.titleTextAttributesTransformer = .init({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.title3
            return outgoing
        })
        return configuration
    }
}
