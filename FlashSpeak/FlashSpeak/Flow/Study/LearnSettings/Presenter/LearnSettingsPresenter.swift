//
//  LearnSettingsPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

protocol LearnSettingsViewInput {
    func configureView(
        question: LearnSettings.Question,
        answer: LearnSettings.Answer,
        language: LearnSettings.Language
    )
    func change(setting: LearnSettings.Settings, selected index: Int)
    func didTabBackground()
}

protocol LearnSettingsViewOutput {
    func configureView()
    func changeQuestion(index: Int)
    func changeAnswer(index: Int)
    func changeLanguage(index: Int)
    func viewDidTapBackground()
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
    
    private func getLearnSettings() {
        // Get last leran settings
    }
    
    private func saveLearnSettings() {
        // save to user defaults
    }
}

// MARK: - Functions

extension LearnSettingsPresenter: LearnSettingsViewOutput {
    
    func configureView() {
        viewInput?.configureView(
            question: learnSettings.question,
            answer: learnSettings.answer,
            language: learnSettings.language
        )
    }
    
    func changeQuestion(index: Int) {
        learnSettings.question = LearnSettings.Question.fromRawValue(index: index)
        UserDefaultsHelper.learnQuestionSetting = learnSettings.question.rawValue
    }
    
    func changeAnswer(index: Int) {
        learnSettings.answer = LearnSettings.Answer.fromRawValue(index: index)
        UserDefaultsHelper.learnAnswerSetting = learnSettings.answer.rawValue
    }
    
    func changeLanguage(index: Int) {
        learnSettings.language = LearnSettings.Language.fromRawValue(index: index)
        UserDefaultsHelper.learnLanguageSetting = learnSettings.language.rawValue
    }
    
    func viewDidTapBackground() {
        router?.didSendEventClosure?(.close)
    }
}
