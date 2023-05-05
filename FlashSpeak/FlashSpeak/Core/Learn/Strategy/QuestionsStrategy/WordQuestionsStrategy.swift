//
//  WordQuestionsStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

final class WordQuestionsStrategy: QuestionsStrategy {
    
    func createQuestions(_ words: [Word], source: LearnSettings.Language) -> [Question] {
        let questions: [WordQuestion] = words.map { word in
            var question: WordQuestion
            switch source {
            case .source:
                question = WordQuestion(question: word.source)
            case .target:
                question = WordQuestion(question: word.translation)
            }
            return question
            
        }
        return questions
    }

}
