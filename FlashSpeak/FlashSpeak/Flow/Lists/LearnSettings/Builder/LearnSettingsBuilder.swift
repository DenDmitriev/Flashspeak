//
//  LearnSettingsBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

struct LearnSettingsBuilder {
    static func build(router: LearnSettingsEvent, wordsCount: Int) -> (UIViewController & LearnSettingsViewInput) {
        let presenter = LearnSettingsPresenter(router: router)
        let learnSettingsManager = LearnSettingsManager(wordsCount: wordsCount)
        
        let viewController = LearnSettingsViewController(
            presenter: presenter,
            settingsManager: learnSettingsManager
        )
        
        presenter.viewInput = viewController
        
        return viewController
    }
}
