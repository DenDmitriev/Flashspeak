//
//  ResultPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit
import Combine

protocol ResultViewInput {
    var resultViewModels: [ResultViewModel] { get set }
    
    func updateResults()
}

protocol ResultViewOutput {
    func subscribe()
    func viewDidTapBackground()
}

class ResultPresenter: ObservableObject {
    
    // MARK: - Properties
    
    weak var viewController: (UIViewController & ResultViewInput)?
    var router: ResultEvent?
    
    @Published var learnings: [Learn]
    
    // MARK: - Private properties
    
    private var store = Set<AnyCancellable>()
    
    // MARK: - Constraction
    
    init(router: ResultEvent, learnings: [Learn]) {
        self.router = router
        self.learnings = learnings
    }
    
    // MARK: - Private functions
}

// MARK: - Functions

extension ResultPresenter: ResultViewOutput {
    
    func subscribe() {
        self.$learnings
            .receive(on: RunLoop.main)
            .sink(receiveValue: { learnings in
                guard let lastLearn = learnings.last else { return }
                LearnResults.allCases.forEach { result in
                    let resultString: String
                    switch result {
                    case .duration:
                        resultString = lastLearn.duration()
                    case .rights:
                        resultString = "\(lastLearn.result)/\(lastLearn.count)"
                    }
                    let resultViewModel = ResultViewModel(
                        result: resultString,
                        description: result.description
                    )
                    self.viewController?.resultViewModels.append(resultViewModel)
                }
                self.viewController?.updateResults()
            })
            .store(in: &store)
    }
    
    func viewDidTapBackground() {
        router?.didSendEventClosure?(.close)
    }
}
