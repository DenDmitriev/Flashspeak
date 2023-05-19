//
//  LearnBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit

struct LearnBuilder {
    static func build(
        router: LearnEvent,
        list: List
    ) -> UIViewController & LearnViewInput {
        
        let settings = LearnSettings(
            question: UserDefaultsHelper.learnQuestionSetting,
            answer: UserDefaultsHelper.learnAnswerSetting,
            language: UserDefaultsHelper.learnLanguageSetting
        )
        let presenter = LearnPresenter(router: router, list: list, settings: settings)
        
        let viewController = LearnViewController(
            presenter: presenter,
            settings: settings
        )
        
        presenter.viewController = viewController
        
        return viewController
    }
}
