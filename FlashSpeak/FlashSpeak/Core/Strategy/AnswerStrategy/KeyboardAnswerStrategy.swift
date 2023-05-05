//
//  KeyboardAnswerStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

final class KeyboardAnswerStrategy: AnswerStrategy {
    typealias Element = KeyboardAnswer
    
    func createAnswers(_ words: [Word], source: LearnSettings.Language) -> [Answer] {
        return []
    }
}
