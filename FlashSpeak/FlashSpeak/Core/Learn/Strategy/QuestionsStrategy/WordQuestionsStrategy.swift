//
//  WordQuestionsStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

final class WordQuestionsStrategy: QuestionsStrategy {
    
    func createQuestions(_ words: [Word], source: LearnLanguage.Language) -> [Question] {
        let questions: [Question] = words.map { word in
            var question: Question
            switch source {
            case .source:
                question = Question(question: word.source)
            case .target:
                question = Question(question: word.translation)
            }
            return question
            
        }
        return questions
    }

}
