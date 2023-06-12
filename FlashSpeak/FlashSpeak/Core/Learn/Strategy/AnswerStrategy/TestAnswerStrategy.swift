//
//  TestAnswerStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

final class TestAnswerStrategy: AnswerStrategy {
    
    /// Minimal words in list
    enum AnswersCount: Int {
        case four = 4
        case six = 6
    }
    
    func createAnswers(_ words: [Word], source: LearnLanguage.Language) -> [Answer] {
        let answers: [TestAnswer] = words.map { word in
            var testAnswers = [String]()
            
            var answerWords = words
            let rightAnswer = createRightAnswer(kind: source, word: word)
            testAnswers.append(rightAnswer.lowercased())
            removeWord(&answerWords, rightAnswer, source: source)
            
            let answersCount = AnswersCount.six.rawValue
            if answerWords.count >= answersCount {
                Array(1...(answersCount - 1)).forEach({ _ in
                    let wrongAnswer = createWrongAnswer(kind: source, words: answerWords)
                    testAnswers.append(wrongAnswer.lowercased())
                    removeWord(&answerWords, wrongAnswer, source: source)
                })
            }
            
            testAnswers.shuffle()
            
            return TestAnswer(answer: nil, words: testAnswers)
        }
        
        return answers
    }
    
    private func createRightAnswer(kind: LearnLanguage.Language, word: Word) -> String {
        switch kind {
        case .source:
            return word.translation
        case .target:
            return word.source
        }
    }
    
    private func createWrongAnswer(kind: LearnLanguage.Language, words: [Word]) -> String {
        let answer: String
        
        switch kind {
        case .source:
            answer = words.randomElement()?.translation ?? "N/A"
        case .target:
            answer = words.randomElement()?.source ?? "N/A"
        }
        
        return answer
    }
    
    private func removeWord(_ answerWords: inout [Word], _ answer: String, source: LearnLanguage.Language) {
        switch source {
        case .source:
            answerWords.removeAll(where: { $0.translation == answer })
        case .target:
            answerWords.removeAll(where: { $0.source == answer })
        }
    }
}
