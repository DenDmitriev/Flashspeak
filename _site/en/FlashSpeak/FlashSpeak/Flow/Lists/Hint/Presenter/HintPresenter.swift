//
//  HintPresenter.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 22.05.2023.
//

import UIKit

protocol HintViewInput {
    func didTabBackground()
}

protocol HintViewOutput {
    var router: HintEvent? { get }
    
    func viewDidTapBackground()
}

class HintPresenter: ObservableObject {
    
    var router: HintEvent?
    weak var viewInput: (UIViewController & HintViewInput)?
    
    
    init(router: HintEvent) {
        self.router = router
    }
}

extension HintPresenter: HintViewOutput {
  
    func viewDidTapBackground() {
        router?.didSendEventClosure?(.close)
    }
}
