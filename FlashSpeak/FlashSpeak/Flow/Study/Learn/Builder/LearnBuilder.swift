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
        let collectionDataSource = LearnCollectionViewDataSource()
        let collectionDelegate = LearnCollectionViewDelegate()
        let textFieldDelegate = LearnTextFieldDelegate()
        
        let viewController = LearnViewController(
            presenter: presenter,
            answerCollectionDelegate: collectionDelegate,
            answerCollectionDataSource: collectionDataSource,
            answerTextFieldDelegate: textFieldDelegate
        )
        
        presenter.viewController = viewController
        
        collectionDelegate.viewController = viewController
        collectionDelegate.answerType = settings.answer
        
        collectionDataSource.viewController = viewController
        collectionDataSource.answerType = settings.answer
        
        textFieldDelegate.viewController = viewController
        
        return viewController
    }
}
