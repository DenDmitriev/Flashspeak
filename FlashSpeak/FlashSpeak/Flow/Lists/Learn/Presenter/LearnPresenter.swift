//
//  LearnPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit

protocol LearnViewInput {
    var answersCount: Int { get }
    var question: Question { get set }
    var answer: Answer { get set }
    
    /// Update question and answer view
    func update(exercise: Exercise)
    /// Main action answer, for testDidAnswer(index:) and keyboardDidAnswer()
    func didAnsewred(answer: Answer)
    /// Highlight user answers view
    func highlightAnswer(isRight: Bool, index: Int?)
    /// Progress learn from 0 to 1
    func setProgress(isRight: Bool, index: Int)
    /// Activity indicator for wait image loader
    func speechDidTap()
}

protocol LearnViewOutput {
    var list: List { get set }
    var router: LearnEvent { get }
    
    /// Start learning
    func update()
    /// Answer received. Checking the answer by type and highlighting the answer view.
    func didAnsewred(answer: Answer)
    func speechDidTap()
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
            manager.response(userAnswer: answer) { isRight, index in
                let rightIndex = self.manager.rightIndexTest()
                let userIndex = self.manager.indexTest(userAnswer: answer)
                self.viewController?.highlightAnswer(isRight: true, index: rightIndex)
                if !isRight {
                    self.viewController?.highlightAnswer(isRight: false, index: userIndex)
                }
                self.viewController?.setProgress(isRight: isRight, index: index)
            }
        case .keyboard:
            manager.response(userAnswer: answer) { isRight, index in
                self.viewController?.highlightAnswer(isRight: isRight, index: .zero)
                self.viewController?.setProgress(isRight: isRight, index: index)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.manager.next()
        }
    }
    
    func speechDidTap() {
        manager.speech()
    }
}

extension LearnPresenter: LearnManagerDelegate {
    
    func receive(exercise: Exercise, settings: LearnSettings, cardIndex: CardIndex) {
        viewController?.update(exercise: exercise)
    }
    
    func complete(learn: Learn, mistakes: [Word: String]) {
        list.learns.append(learn)
        router.didSendEventClosure?(.complete(list: list, mistakes: mistakes))
    }
    
    func spinner(isActive: Bool, title: String?) {
        // add activiti indicator
    }
}
