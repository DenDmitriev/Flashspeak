//
//  LearnManager.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit
import Combine
import AVFoundation

protocol LearnManagerDelegate: AnyObject {
    /// Question session end event
    func complete(learn: Learn, mistakes: [Word: String])
    /// Send to delegate next exercise
    func receive(exercise: Exercise)
    /// Activity indicator for wait image loader
    func spinner(isActive: Bool, title: String?)
    /// Configure Mode
    func timer(mode: LearnTimer.Timer, seconds: Int?)
    /// Configure speaker
    func speaker(mode: LearnSpeaker.Speaker)
}

class LearnManager {
    
    // MARK: - Propetes
    /// Exercise queue
    var exercises = [Exercise]()
    
    weak var delegate: LearnManagerDelegate?
    var settingsManager: LearnSettingsManager
    private let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Private propetes
    
    /// Current exercise
    private var current: Exercise
    /// Сaretaker for learn session result
    private var learnCaretaker: LearnCaretaker
    /// Caretaker for word answer result
    private var wordCaretaker: WordCaretaker
    
    private var store = Set<AnyCancellable>()
    /// Exercise publisher
    private let exerciseSubject = PassthroughSubject<Exercise, LearnManagerError>()
    
    private let addImageFlag: Bool
    
    /// Creator for questions queue by strategy
    private var questionsStrategy: any QuestionsStrategy {
        switch settingsManager.questionAdapter {
        case .word:
            return WordQuestionsStrategy()
        case .image:
            return ImageQuestionsStrategy()
        case .wordImage:
            return WordImageQuestionsStrategy()
        }
    }
    
    /// Creator for answers queue by strategy
    private var answerStrategy: any AnswerStrategy {
        switch settingsManager.answer {
        case .test:
            return TestAnswerStrategy()
        case .keyboard:
            return KeyboardAnswerStrategy()
        }
    }
    
    // MARK: - Constraction
    
    init(words: [Word], listID: UUID, addImageFlag: Bool) {
        self.settingsManager = LearnSettingsManager(wordsCount: words.count, imageFlag: addImageFlag)
        self.learnCaretaker = LearnCaretaker(wordsCount: words.count, listID: listID)
        self.wordCaretaker = WordCaretaker(words: words)
        self.addImageFlag = addImageFlag
        self.current = Exercise(
            word: Word(source: "", translation: ""),
            question: Question(question: ""),
            answer: TestAnswer(words: [])
        )
        createExercises(words: words)
        subscribe()
    }
    
    // MARK: - Private Functions
    
    /// Publisher for queue
    private func subscribe() {
        exerciseSubject
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.wordCaretaker.finish()
                    self.learnCaretaker.finish()
                    self.delegate?.complete(
                        learn: self.learnCaretaker.learn,
                        mistakes: self.wordCaretaker.mistakeWords
                    )
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { exercise in
                self.delegate?.receive( exercise: exercise)
            }
            .store(in: &store)
    }
    
    private func publish() {
        if
            addImageFlag,
            settingsManager.questionAdapter != .word,
            current.question.image == nil
         {
            let title = NSLocalizedString("Image loading", comment: "Title")
            delegate?.spinner(isActive: true, title: title)
            loadImage(for: current.word)
                .receive(on: RunLoop.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.delegate?.spinner(isActive: false, title: nil)
                        self.exerciseSubject.send(self.current)
                    }
                } receiveValue: { image in
                    self.current.question.image = image
                }
                .store(in: &store)
        } else {
            exerciseSubject.send(current)
        }
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
                    answer: answers[index]
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
        let questions = questionsStrategy.createQuestions(words, source: settingsManager.language)
        return questions
    }
    
    private func createAnswers(words: [Word]) -> [Answer] {
        let answers = answerStrategy.createAnswers(words, source: settingsManager.language)
        return answers
    }
    
    private func configureMode(timer: LearnTimer.Timer, sound: LearnSpeaker.Speaker) {
        let seconds = settingsManager.settings[.mode]?.first?.value
        delegate?.timer(mode: timer, seconds: seconds)
        delegate?.speaker(mode: sound)
    }
    
    private func rightAnswer() -> String {
        switch settingsManager.language {
        case .source:
            return current.word.translation
        case .target:
            return current.word.source
        }
    }
    
    private func cardIndex(_ exercise: Exercise) -> CardIndex {
        let currentIndex = exercises.firstIndex { $0.word.id == exercise.word.id } ?? .zero
        var allIndexes = exercises.count
        
        // If suddenly get 0
        if allIndexes == .zero {
            allIndexes = 1
        }

        return CardIndex(current: currentIndex, count: allIndexes)
    }
    
    private func loadImage(for word: Word) -> AnyPublisher<UIImage?, Never> {
        return Just(word.imageURL)
            .flatMap({ imageURL -> AnyPublisher<UIImage?, Never> in
                guard
                    let url = imageURL
                else {
                    return Just(UIImage(named: "placeholder"))
                        .eraseToAnyPublisher()
                }
                return ImageLoader.shared.loadImage(from: url)
            })
            .eraseToAnyPublisher()
    }
    
    // MARK: - Functions
    
    func start() {
        configureMode(timer: settingsManager.timer, sound: settingsManager.sound)
        publish()
    }
    
    func next() {
        guard
            current.word.id != exercises.last?.word.id,
            let currentIndex = exercises.firstIndex(where: { $0.word.id == current.word.id })
        else {
            exerciseSubject.send(completion: .finished)
            return
        }
        let nextIndex = exercises.index(after: currentIndex)
        current = exercises[nextIndex]
        
        publish()
    }
    
    func over() {
        exerciseSubject.send(completion: .finished)
    }
    
    func response(userAnswer: Answer, comletion: @escaping ((Bool, Int) -> Void)) {
        let rightAnswer = rightAnswer()
        
        let isRight: Bool
        if rightAnswer == userAnswer.answer {
            isRight = true
        } else {
            isRight = false
        }
        
        wordCaretaker.addResult(answer: isRight, for: current.word.id, mistake: userAnswer.answer ?? "")
        learnCaretaker.addResult(answer: isRight)
        
        let currentIndex = exercises.firstIndex { current.word.id == $0.word.id } ?? .zero
        comletion(isRight, currentIndex)
    }
    
    func speech() {
        // Speech text
        let text = current.question.question
        
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: text)

        // Configure the utterance.
        utterance.rate = 0.4
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8

        // Retrieve voice bu setting language
        let languageCode = UserDefaultsHelper.targetLanguage
        guard let language = Language.language(by: languageCode) else { return }
        let voice = AVSpeechSynthesisVoice(language: language.speechVoice)

        // Assign the voice to the utterance.
        utterance.voice = voice
        
        synthesizer.speak(utterance)
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
