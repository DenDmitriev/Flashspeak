//
//  ResultPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

protocol ResultViewInput {
    
}

protocol ResultViewOutput {
    
    func viewDidTapBackground()
}

class ResultPresenter {
    
    // MARK: - Properties
    
    weak var viewController: (UIViewController & ResultViewInput)?
    var router: ResultEvent?
    var learn: Learn
    
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
    
    func viewDidTapBackground() {
        router?.didSendEventClosure?(.close)
    }
}
