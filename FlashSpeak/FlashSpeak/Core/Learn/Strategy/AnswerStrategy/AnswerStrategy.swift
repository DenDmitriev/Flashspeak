//
//  AnswerStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

protocol AnswerStrategy: AnyObject {
    
    func createAnswers(_ words: [Word], source: LearnLanguage.Language) -> [Answer]
}
