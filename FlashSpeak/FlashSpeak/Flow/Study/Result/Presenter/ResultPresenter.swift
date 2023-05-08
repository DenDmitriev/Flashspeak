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
    @Published var learn: Learn
    var store = Set<AnyCancellable>()
    
    // MARK: - Private properties
    
    // MARK: - Constraction
    
    init(router: ResultEvent, learn: Learn) {
        self.router = router
        self.learn = learn
    }
    
    // MARK: - Private functions
}

// MARK: - Functions

extension ResultPresenter: ResultViewOutput {
    
    func subscribe() {
        self.$learn
            .receive(on: RunLoop.main)
            .sink(receiveValue: { learn in
                LearnResults.allCases.forEach { result in
                    let resultString: String
                    switch result {
                    case .duration:
                        resultString = learn.duration()
                    case .rights:
                        resultString = "\(learn.result)/\(learn.count)"
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
