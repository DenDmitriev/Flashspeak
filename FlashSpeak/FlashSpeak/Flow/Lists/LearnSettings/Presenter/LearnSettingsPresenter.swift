//
//  LearnSettingsPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

protocol LearnSettingsViewInput {
    var learnSettingsManager: LearnSettingsManager { get set }
}

protocol LearnSettingsViewOutput {
    
}

class LearnSettingsPresenter {
    
    // MARK: - Properties
    var router: LearnSettingsEvent?
    weak var viewInput: (UIViewController & LearnSettingsViewInput)?
    
    // MARK: - Private properties
    
    // MARK: - Constraction
    
    init(router: LearnSettingsEvent) {
        self.router = router
    }
    
    // MARK: - Private functions
}

// MARK: - Functions

extension LearnSettingsPresenter: LearnSettingsViewOutput {
}
