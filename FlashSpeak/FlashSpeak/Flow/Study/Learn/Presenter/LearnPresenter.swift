//
//  LearnPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit
import Combine

protocol LearnViewInput {
    var question: Question { get set }
    var answer: Answer { get set }
    /// Required to bind a delegate to a cell
    var answerTextFieldDelegate: UITextFieldDelegate { get }
    
    /// Initial configure answer view by type
    func configureAnswerView(settings: LearnSettings.Answer)
    /// Update question and answer view
    func configure(exercise: Exercise, settings: LearnSettings.Answer)
    /// Action for test type answer, where index is selected user answer
    func testDidAnswer(index: Int)
    /// Action for keyboard type answer
    func keyboardDidAnswer()
    /// Main action answer, for testDidAnswer(index:) and keyboardDidAnswer()
    func didAnsewred(answer: Answer)
    /// Highlight user answers view
    func highlightAnswer(isRight: Bool, index: Int?, settings: LearnSettings.Answer)
}

protocol LearnViewOutput {
    var list: List { get set }
    var router: LearnEvent { get }
    
    /// Request from view controller for initial configure
    func getConfigure()
    /// Answer received. Checking the answer by type and highlighting the answer view.
    func didAnsewred(answer: Answer)
    /// Change question and answer. Get exercise from manager and set to view
}

class LearnPresenter {
    
    // MARK: - Properties
    
    var list: List
    var router: LearnEvent
    weak var viewController: (UIViewController & LearnViewInput)?
    
    // MARK: - Private properties
    
    private var manager: LearnManager
//    private var store = Set<AnyCancellable>()
//    private let subject = PassthroughSubject<Exercise, Never>()
    
    // MARK: - Constracions
    
    init(router: LearnEvent, list: List, settings: LearnSettings) {
        self.list = list
        self.router = router
        self.manager = LearnManager(words: list.words, settings: settings)
        manager.delegate = self
    }
    
    // MARK: - Private functions
    
    private func configureAnswerView() {
        viewController?.configureAnswerView(settings: manager.settings.answer)
    }
    
    private func start() {
        manager.start()
    }
}

extension LearnPresenter: LearnViewOutput {
    
    func getConfigure() {
        configureAnswerView()
        start()
    }
    
    func didAnsewred(answer: Answer) {
        switch manager.settings.answer {
        case .test:
            let isRight = manager.isRight(userAnswer: answer)
            let rightIndex = manager.rightIndexTest()
            let userIndex = manager.indexTest(userAnswer: answer)
            if !isRight {
                viewController?.highlightAnswer(isRight: false, index: userIndex, settings: .test)
            }
            viewController?.highlightAnswer(isRight: true, index: rightIndex, settings: .test)
        case .keyboard:
            let isRight = manager.isRight(userAnswer: answer)
            if isRight {
                viewController?.highlightAnswer(isRight: true, index: .zero, settings: .keyboard)
            } else {
                viewController?.highlightAnswer(isRight: false, index: .zero, settings: .keyboard)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.manager.answered()
        }
    }
}

extension LearnPresenter: LearnManagerDelegate {
    
    func receive(exercise: Exercise, answer: LearnSettings.Answer) {
        viewController?.configure(exercise: exercise, settings: answer)
    }
    
    func complete(learn: Learn) {
        print(#function, learn)
        router.didSendEventClosure?(.complete(learn: learn))
    }
}
