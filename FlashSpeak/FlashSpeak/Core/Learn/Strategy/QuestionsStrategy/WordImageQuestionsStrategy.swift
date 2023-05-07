//
//  WordImageQuestionsStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

class WordImageQuestionsStrategy: QuestionsStrategy {
    
    func createQuestions(_ words: [Word], source: LearnSettings.Language) -> [Question] {
        let questions: [Question] = words.map { word in
            
            var question: WordImageQuestion
            
            switch source {
            case .source:
                question = WordImageQuestion(question: word.source, image: nil)
            case .target:
                question = WordImageQuestion(question: word.translation, image: nil)
            }
            
            return question
            
        }
        
        return questions
    }
}
