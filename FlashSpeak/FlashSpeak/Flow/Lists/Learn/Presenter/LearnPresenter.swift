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
    
    /// Update question and answer view
    func update(exercise: Exercise)
    /// Main action answer, for testDidAnswer(index:) and keyboardDidAnswer()
    func didAnsewred(answer: Answer)
    /// Highlight user answers view
    func highlightAnswer(isRight: Bool, index: Int?)
    /// Progress learn from 0 to 1
    func setCardIndex(_ cardIndex: CardIndex)
    /// Activity indicator for wait image loader
    func spinner(isActive: Bool, title: String?)
}

protocol LearnViewOutput {
    var list: List { get set }
    var router: LearnEvent { get }
    
    /// Start learning
    func update()
    
    /// Answer received. Checking the answer by type and highlighting the answer view.
    func didAnsewred(answer: Answer)
}

class LearnPresenter {
    
    // MARK: - Properties
    
    var list: List
    var router: LearnEvent
    weak var viewController: (UIViewController & LearnViewInput)?
    
    // MARK: - Private properties
    
    private var manager: LearnManager
    private let coreData = CoreDataManager.instance
    
    // MARK: - Constracions
    
    init(router: LearnEvent, list: List, settings: LearnSettings) {
        self.list = list
        self.router = router
        self.manager = LearnManager(
            words: list.words,
            settings: settings,
            listID: list.id,
            addImageFlag: list.addImageFlag
        )
        manager.delegate = self
    }
    
    // MARK: - Private functions
    
    private func start() {
        manager.start()
    }
}

extension LearnPresenter: LearnViewOutput {
    
    func update() {
        start()
    }
    
    func didAnsewred(answer: Answer) {
        switch manager.settings.answer {
        case .test:
            manager.response(userAnswer: answer) { isRight in
                let rightIndex = self.manager.rightIndexTest()
                let userIndex = self.manager.indexTest(userAnswer: answer)
                self.viewController?.highlightAnswer(isRight: true, index: rightIndex)
                if !isRight {
                    self.viewController?.highlightAnswer(isRight: false, index: userIndex)
                }
            }
        case .keyboard:
            manager.response(userAnswer: answer) { isRight in
                self.viewController?.highlightAnswer(isRight: isRight, index: .zero)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.manager.next()
        }
    }
}

extension LearnPresenter: LearnManagerDelegate {
    
    func receive(exercise: Exercise, settings: LearnSettings, cardIndex: CardIndex) {
        viewController?.update(exercise: exercise)
        viewController?.setCardIndex(cardIndex)
    }
    
    func complete(learn: Learn) {
        viewController?.setCardIndex(CardIndex(current: list.words.count, count: list.words.count))
        router.didSendEventClosure?(.complete(learn: learn))
    }
    
    func spinner(isActive: Bool, title: String?) {
        viewController?.spinner(isActive: isActive, title: title)
    }
}
