//
//  LearnSettingsViewModel.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import Foundation

struct LearnSettingsViewModel {
    var questions: [String]
    var answers: [String]
    var languages: [String]
    
    init() {
        self.questions = LearnSettings.Question.allCases.map({ $0.name })
        self.answers = LearnSettings.Answer.allCases.map({ $0.name })
        self.languages = LearnSettings.Language.allCases.map({ $0.name })
    }
}
