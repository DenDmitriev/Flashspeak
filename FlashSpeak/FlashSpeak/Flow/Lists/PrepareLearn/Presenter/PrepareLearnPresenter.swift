//
//  PrepareLearnPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

protocol PrepareLearnInput {
    
}

protocol PrepareLearnOutput {
    
}

class PrepareLearnPresenter {
    
    // MARK: - Properties
    
    weak var viewController: (UIViewController & PrepareLearnInput)?
    
    // MARK: - Private properties
    
    private let router: PrepareLearnEvent?
    
    // MARK: - Constraction
    
    init(router: PrepareLearnEvent) {
        self.router = router
    }
    
    // MARK: - Private functions
}

// MARK: - Functions
extension PrepareLearnPresenter: PrepareLearnOutput {
    
}
