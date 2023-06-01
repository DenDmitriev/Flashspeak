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
        
        let question = UserDefaultsHelper.learnQuestionSetting
        let answer = UserDefaultsHelper.learnAnswerSetting
        let language = UserDefaultsHelper.learnLanguageSetting
        let learnSettings = LearnSettings(
            question: question,
            answer: answer,
            language: language
        )
        
        let viewController = LearnSettingsViewController(
            presenter: presenter,
            learnSettings: learnSettings
        )
        
        presenter.viewInput = viewController
        
        return viewController
    }
}
