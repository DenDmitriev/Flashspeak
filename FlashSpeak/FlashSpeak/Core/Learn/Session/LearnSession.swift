//
//  LearnSession.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation
import Combine

protocol LearnSessionDelegate: AnyObject {
    func complete(learn: Learn)
}

class LearnSession {
    
    // MARK: - Propetes
    weak var delegate: LearnSessionDelegate?
    var settings: LearnSettings
    
    // MARK: - Private propetes
    
    private var exercises = [Exercise]()
    private var current: Int = .zero
    private var learnCaretaker: LearnCaretaker
    private var wordCaretaker: WordCaretaker
    private var store = Set<AnyCancellable>()
    
    private var questionsStrategy: any QuestionsStrategy {
        switch settings.question {
        case .word:
            return WordQuestionsStrategy()
        case .wordImage:
            return WordImageQuestionsStrategy()
        case .image:
            return ImageQuestionsStrategy()
        }
    }
    
    private var answerStrategy: any AnswerStrategy {
        switch settings.answer {
        case .test:
            return TestAnswerStrategy()
        case .keyboard:
            return KeyboardAnswerStrategy()
        }
    }
    
    // MARK: - Constraction
    
    init(words: [Word], settings: LearnSettings) {
        self.settings = settings
        self.learnCaretaker = LearnCaretaker()
        self.wordCaretaker = WordCaretaker()
        createExercises(words: words)
    }
    
    // MARK: - Functions
    
    func next() -> Exercise? {
        if current < exercises.index(before: exercises.count) {
            let exercise = exercises[current]
            return exercise
        } else {
            return nil
        }
    }
    
    func answered() {
        if current < exercises.index(before: exercises.count) {
            current += 1
        } else {
            wordCaretaker.finish()
            learnCaretaker.finish()
            delegate?.complete(learn: learnCaretaker.learn)
        }
    }
    
    func isRight(userAnswer: Answer) -> Bool {
        let exercise = exercises[current]
        
        let rightAnswer: String
        switch settings.language {
        case .source:
            rightAnswer = exercise.word.translation
        case .target:
            rightAnswer = exercise.word.source
        }
        
        let isRight: Bool
        
        if rightAnswer == userAnswer.answer {
            isRight = true
        } else {
            isRight = false
        }
        
        wordCaretaker.addResult(answer: isRight, word: exercise.word)
        learnCaretaker.addResult(answer: isRight)
        
        return isRight
    }
    
    func rightAnswer() -> String {
        let exercise = exercises[current]
        
        switch settings.language {
        case .source:
            return exercise.word.translation
        case .target:
            return exercise.word.source
        }
    }
    
    func rightIndexTest() -> Int? {
        let exercise = exercises[current]
        let rightAnswer = rightAnswer()
        guard let testAnswer = exercise.answer as? TestAnswer else { return nil }
        let index = testAnswer.words.firstIndex { $0.lowercased() == rightAnswer.lowercased() }
        return index
    }
    
    func indexTest(userAnswer: Answer) -> Int? {
        guard let answer = userAnswer as? TestAnswer else { return nil }
        let index = answer.words.firstIndex { $0.lowercased() == answer.answer?.lowercased() }
        return index
    }
    
    // MARK: - Private Functions
    
    private func createExercises(words: [Word]) {
        let wordsSequence = words.shuffled()
        
        let questions = createQuestions(words: wordsSequence)
        let answers = createAnswers(words: wordsSequence)
        
        wordsSequence
            .enumerated()
            .publisher
            .map { index, word in
                let exercise = Exercise(word: word, question: questions[index], answer: answers[index])
                return exercise
            }
            .sink { exercise in
                self.exercises.append(exercise)
            }
            .store(in: &store)
    }
    
    private func createQuestions(words: [Word]) -> [Question] {
        let questions = questionsStrategy.createQuestions(words, source: settings.language)
        return questions
    }
    
    private func createAnswers(words: [Word]) -> [Answer] {
        let answers = answerStrategy.createAnswers(words, source: settings.language)
        return answers
    }
}
