//
//  LearnSettingsPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

protocol LearnSettingsViewInput {
    var learnSettings: LearnSettings { get set }
}

protocol LearnSettingsViewOutput {
    func settingsChanged(_ settings: LearnSettings)
}

class LearnSettingsPresenter {
    
    // MARK: - Properties
    
    var learnSettings: LearnSettings
    var router: LearnSettingsEvent?
    weak var viewInput: (UIViewController & LearnSettingsViewInput)?
    
    // MARK: - Private properties
    
    // MARK: - Constraction
    
    init(router: LearnSettingsEvent) {
        self.router = router
        let question = UserDefaultsHelper.learnQuestionSetting
        let answer = UserDefaultsHelper.learnAnswerSetting
        let language = UserDefaultsHelper.learnLanguageSetting
        self.learnSettings = LearnSettings(question: question, answer: answer, language: language)
    }
    
    // MARK: - Private functions
}

// MARK: - Functions

extension LearnSettingsPresenter: LearnSettingsViewOutput {
    
    func settingsChanged(_ settings: LearnSettings) {
        UserDefaultsHelper.learnQuestionSetting = settings.question.rawValue
        UserDefaultsHelper.learnAnswerSetting = settings.answer.rawValue
        UserDefaultsHelper.learnLanguageSetting = settings.language.rawValue
    }
}
