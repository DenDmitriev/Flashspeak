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
    var answer: TestAnswer { get set }
    func set(exercise: Exercise)
    func didSelectItemAt(index: Int)
    func didAnsewred(answer: Answer)
    func highlightAnswer(isRight: Bool, index: Int?)
}

protocol LearnViewOutput {
    var list: List { get set }
    var router: LearnEvent { get }
    
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
    
    func nextQuestion() {
        if let exercise = session.next() {
            viewController?.set(exercise: exercise)
        }
    }
    
    func subscribe() {
        self.$session
            .receive(on: RunLoop.main)
            .sink { [weak self] session in
                session.delegate = self
                if let exercise = session.next() {
                    self?.viewController?.set(exercise: exercise)
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
                viewController?.highlightAnswer(isRight: false, index: userIndex)
            }
            viewController?.highlightAnswer(isRight: true, index: rightIndex)
        case .keyboard:
            let isRight = session.isRight(userAnswer: answer)
            if isRight {
                viewController?.highlightAnswer(isRight: true, index: nil)
            } else {
                viewController?.highlightAnswer(isRight: false, index: nil)
            }
        }
        session.answered()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
