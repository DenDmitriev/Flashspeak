//
//  QuestionsStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

protocol QuestionsStrategy: AnyObject {
    func createQuestions(_ words: [Word], source: LearnLanguage.Language) -> [Question]
}
