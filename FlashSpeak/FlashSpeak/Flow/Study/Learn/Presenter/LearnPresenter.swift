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
    var answerTextFieldDelegate: UITextFieldDelegate { get }
    
    func configureAnswerView(settings: LearnSettings.Answer)
    func configure(exercise: Exercise, settings: LearnSettings.Answer)
    func testDidAnswer(index: Int)
    func keyboardDidAnswer()
    func didAnsewred(answer: Answer)
    func highlightAnswer(isRight: Bool, index: Int?, settings: LearnSettings.Answer)
}

protocol LearnViewOutput {
    var list: List { get set }
    var router: LearnEvent { get }
    
    func getAnswerConfigure()
    func didAnsewred(answer: Answer)
    func nextQuestion()
    func subscribe()
}

class LearnPresenter: ObservableObject {
    
    // MARK: - Properties
    
    var list: List
    @Published var session: LearnSession
    
    var router: LearnEvent
    weak var viewController: (UIViewController & LearnViewInput)?
    
    // MARK: - Private properties
    
    private var store = Set<AnyCancellable>()
    
    // MARK: - Constracions
    
    init(router: LearnEvent, list: List, settings: LearnSettings) {
        self.list = list
        self.router = router
        self.session = LearnSession(words: list.words, settings: settings)
    }
    
    // MARK: - Private functions
    
}

extension LearnPresenter: LearnViewOutput {
    
    func getAnswerConfigure() {
        configureAnswerView()
    }
    
    func configureAnswerView() {
        viewController?.configureAnswerView(settings: session.settings.answer)
    }
    
    func nextQuestion() {
        if let exercise = session.next() {
            viewController?.configure(exercise: exercise, settings: session.settings.answer)
        }
    }
    
    func subscribe() {
        self.$session
            .receive(on: RunLoop.main)
            .sink { [weak self] session in
                session.delegate = self
                if let exercise = session.next() {
                    self?.viewController?.configure(exercise: exercise, settings: session.settings.answer)
                }
            }
            .store(in: &store)
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
