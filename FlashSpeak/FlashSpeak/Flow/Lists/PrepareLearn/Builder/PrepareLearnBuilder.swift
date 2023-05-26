//
//  PrepareLearnBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

struct PrepareLearnBuilder {
    static func build(router: PrepareLearnEvent, list: List) -> UIViewController & PrepareLearnInput {
        let presenter = PrepareLearnPresenter(router: router, list: list)
        
        let question = UserDefaultsHelper.learnQuestionSetting
        let answer = UserDefaultsHelper.learnAnswerSetting
        let language = UserDefaultsHelper.learnLanguageSetting
        let learnSettings = LearnSettings(
            question: question,
            answer: answer,
            language: language
        )
        
        let viewController = PrepareLearnViewController(
            presenter: presenter,
            learnSettings: learnSettings
        )
        
        presenter.viewController = viewController
        
        return viewController
    }
}
