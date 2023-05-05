//
//  ImageQuestionsStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

class ImageQuestionsStrategy: QuestionsStrategy {
    
    func createQuestions(_ words: [Word], source: LearnSettings.Language) -> [Question] {
        let questions: [Question] = words.map { word in
            
            var question: Question
            
            switch source {
            case .source:
                question = ImageQuestion(question: word.translation, image: word.imageURL)
            case .target:
                question = ImageQuestion(question: word.source, image: word.imageURL)
            }
            
            return question
            
        }
        return questions
    }
}
