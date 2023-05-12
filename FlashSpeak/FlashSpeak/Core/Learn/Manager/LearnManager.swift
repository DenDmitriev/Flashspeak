//
//  LearnManager.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit
import Combine

protocol LearnManagerDelegate: AnyObject {
    /// Question session end event
    func complete(learn: Learn)
    /// Send to delegate next exercise
    func receive(exercise: Exercise, settings: LearnSettings, progress: Float)
}

class LearnManager {
    
    // MARK: - Propetes
    /// Exercise queue
    var exercises = [Exercise]()
    
    weak var delegate: LearnManagerDelegate?
    var settings: LearnSettings
    
    // MARK: - Private propetes
    
    /// Current exercise
    private var current: Exercise
    /// Сaretaker for learn session result
    private var learnCaretaker: LearnCaretaker
    /// Caretaker for word answer result
    private var wordCaretaker: WordCaretaker
    
    private var store = Set<AnyCancellable>()
    /// Exercise publisher
    private let mainPublisher = PassthroughSubject<Exercise, Never>()
    private let preparationPublisher = PassthroughSubject<Exercise, Never>()
    
    private let networkService = NetworkService()
    
    private let addImageFlag: Bool
    
    /// Creator for questions queue by strategy
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
    
    /// Creator for answers queue by strategy
    private var answerStrategy: any AnswerStrategy {
        switch settings.answer {
        case .test:
            return TestAnswerStrategy()
        case .keyboard:
            return KeyboardAnswerStrategy()
        }
    }
    
    // MARK: - Constraction
    
    init(words: [Word], settings: LearnSettings, listID: UUID, addImageFlag: Bool) {
        self.settings = settings
        self.learnCaretaker = LearnCaretaker(wordsCount: words.count, listID: listID)
        self.wordCaretaker = WordCaretaker(words: words)
        self.addImageFlag = addImageFlag
        self.current = Exercise(
            word: Word(source: "", translation: ""),
            question: Question(question: ""),
            answer: TestAnswer(words: []),
            settings: settings
        )
        createExercises(words: words)
        subscribe()
    }
    
    // MARK: - Private Functions
    
    /// Publisher for queue
    private func subscribe() {
        mainPublisher
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.wordCaretaker.finish()
                    self.learnCaretaker.finish()
                    self.delegate?.complete(learn: self.learnCaretaker.learn)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { exercise in
                self.delegate?.receive(
                    exercise: exercise,
                    settings: self.settings,
                    progress: self.progress(exercise)
                )
            }
            .store(in: &store)
        
        preparationPublisher
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { _ in
                if self.addImageFlag {
                    self.getImage(for: self.current)
                } else {
                    self.mainPublisher.send(self.current)
                }
            }
            .store(in: &store)
        
    }
    
    private func createExercises(words: [Word]) {
        let wordsSequence = words.shuffled()
        
        let questions = createQuestions(words: wordsSequence)
        let answers = createAnswers(words: wordsSequence)
        
        wordsSequence
            .enumerated()
            .publisher
            .map { index, word in
                let exercise = Exercise(
                    word: word,
                    question: questions[index],
                    answer: answers[index],
                    settings: settings
                )
                return exercise
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.current = self.exercises.first ?? self.exercises[.zero]
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { exercise in
                self.exercises.append(exercise)
            })
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
    
    private func getImage(for exercise: Exercise) {
        guard
            let url = exercise.word.imageURL
        else { return }
        networkService.imageLoader(url: url)
            .receive(on: RunLoop.main)
            .sink { image in
                self.current.question.image = image
                self.mainPublisher.send(self.current)
            }
            .store(in: &store)
    }
    
    private func rightAnswer() -> String {
        switch settings.language {
        case .source:
            return current.word.translation
        case .target:
            return current.word.source
        }
    }
    
    private func progress(_ exercise: Exercise) -> Float {
        let currentIndex = exercises.firstIndex { $0.word.id == exercise.word.id } ?? .zero
        var allIndexes = exercises.count
        
        // If suddenly get 0
        if allIndexes == .zero {
            allIndexes = 1
        }
        
        let current = Float(currentIndex)
        let total = Float(allIndexes)
        
        let progress = current / total
        return progress
    }
    
    // MARK: - Functions
    
    func start() {
        preparationPublisher.send(current)
    }
    
    func next() {
        guard
            current.word.id != exercises.last?.word.id,
            let currentIndex = exercises.firstIndex(where: { $0.word.id == current.word.id })
        else {
            mainPublisher.send(completion: .finished)
            return
        }
        let nextIndex = exercises.index(after: currentIndex)
        current = exercises[nextIndex]
        preparationPublisher.send(current)
    }
    
    
    func response(userAnswer: Answer, comletion: @escaping ((Bool) -> Void)) {
        let rightAnswer = rightAnswer()
        
        let isRight: Bool
        if rightAnswer == userAnswer.answer {
            isRight = true
        } else {
            isRight = false
        }
        
        wordCaretaker.addResult(answer: isRight, for: current.word.id)
        learnCaretaker.addResult(answer: isRight)
        comletion(isRight)
    }
    
    // MARK: Test answer method
    
    func rightIndexTest() -> Int? {
        let rightAnswer = rightAnswer()
        guard let testAnswer = current.answer as? TestAnswer else { return nil }
        let index = testAnswer.words.firstIndex { $0.lowercased() == rightAnswer.lowercased() }
        return index
    }
    
    func indexTest(userAnswer: Answer) -> Int? {
        guard let answer = userAnswer as? TestAnswer else { return nil }
        let index = answer.words.firstIndex { $0.lowercased() == answer.answer?.lowercased() }
        return index
    }
}
