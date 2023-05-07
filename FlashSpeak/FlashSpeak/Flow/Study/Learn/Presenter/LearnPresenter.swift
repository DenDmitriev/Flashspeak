//
//  LearnPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit

protocol LearnViewInput {
    var question: Question { get set }
    var answer: Answer { get set }
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
    func nextQuestion()
}

class LearnPresenter {
    
    // MARK: - Properties
    
    var list: List
    var session: LearnSession
    
    var router: LearnEvent
    weak var viewController: (UIViewController & LearnViewInput)?
    
    // MARK: - Private properties
    
    // MARK: - Constracions
    
    init(router: LearnEvent, list: List, settings: LearnSettings) {
        self.list = list
        self.router = router
        self.session = LearnSession(words: list.words, settings: settings)
        session.delegate = self
    }
    
    // MARK: - Private functions
    
    private func configureAnswerView() {
        viewController?.configureAnswerView(settings: session.settings.answer)
    }
}

extension LearnPresenter: LearnViewOutput {
    
    func getConfigure() {
        configureAnswerView()
        nextQuestion()
    }
    
    func nextQuestion() {
        if let exercise = session.next() {
            viewController?.configure(exercise: exercise, settings: session.settings.answer)
        }
    }
    
    func didAnsewred(answer: Answer) {
        switch session.settings.answer {
        case .test:
            let isRight = session.isRight(userAnswer: answer)
            let rightIndex = session.rightIndexTest()
            let userIndex = session.indexTest(userAnswer: answer)
            if !isRight {
                viewController?.highlightAnswer(isRight: false, index: userIndex, settings: .test)
            }
            viewController?.highlightAnswer(isRight: true, index: rightIndex, settings: .test)
        case .keyboard:
            let isRight = session.isRight(userAnswer: answer)
            if isRight {
                viewController?.highlightAnswer(isRight: true, index: .zero, settings: .keyboard)
            } else {
                viewController?.highlightAnswer(isRight: false, index: .zero, settings: .keyboard)
            }
        }
        session.answered()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.nextQuestion()
        }
    }
}

extension LearnPresenter: LearnSessionDelegate {
    
    func complete(learn: Learn) {
        print(#function, learn)
        router.didSendEventClosure?(.complete(learn: learn))
    }
}
