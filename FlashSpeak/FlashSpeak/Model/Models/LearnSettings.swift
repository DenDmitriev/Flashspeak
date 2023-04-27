//
//  LearnSettings.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import Foundation

struct LearnSettings {
    var question: Question
    var answer: Answer
    var language: Language
    
    init(question: Int, answer: Int, language: Int) {
        self.question = Question.allCases.first(where: { $0.rawValue == question }) ?? Question.word
        self.answer = Answer.allCases.first(where: { $0.rawValue == answer }) ?? Answer.test
        self.language = Language.allCases.first(where: { $0.rawValue == language }) ?? Language.target
    }
    
    enum Question: Int, CaseIterable {
        case word, image, wordImage
    }
    
    enum Answer: Int, CaseIterable {
        case test, keyboard
    }
    
    enum Language: Int, CaseIterable {
        case source, target
    }
}
