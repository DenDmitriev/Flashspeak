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
}
