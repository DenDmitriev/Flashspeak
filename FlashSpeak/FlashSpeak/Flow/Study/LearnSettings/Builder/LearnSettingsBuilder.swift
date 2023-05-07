//
//  LearnSettingsBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

struct LearnSettingsBuilder {
    static func build(router: LearnSettingsEvent) -> (UIViewController & LearnSettingsViewInput) {
        let presenter = LearnSettingsPresenter(router: router)
        let gestureRecognizerDelegate = LanguageGestureRecognizerDelegate()
        
        let viewController = LearnSettingsViewController(
            presenter: presenter,
            gestureRecognizerDelegate: gestureRecognizerDelegate
        )
        
        presenter.viewInput = viewController
        
        return viewController
    }
}
