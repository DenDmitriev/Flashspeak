//
//  WordImageQuestionsStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit

class WordImageQuestionsStrategy: QuestionsStrategy {
    
    func createQuestions(_ words: [Word], source: LearnLanguage.Language) -> [Question] {
        let questions: [Question] = words.map { word in
            
            var question: Question
            
            switch source {
            case .source:
                question = Question(question: word.source, image: nil)
            case .target:
                question = Question(question: word.translation, image: nil)
            }
            
            return question
        }
        
        return questions
    }
}
