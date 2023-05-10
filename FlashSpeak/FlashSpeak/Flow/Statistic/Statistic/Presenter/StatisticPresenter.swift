//
//  StatisticPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//

import UIKit

protocol StatisticViewInput {
    
}

protocol StatisticViewOutput {
    
}

class StatisticPresenter {
    
    weak var viewController: (UIViewController & StatisticViewInput)?
    var router: StatisticEvent?
    
    init(router: StatisticEvent) {
        self.router = router
    }
    
}

extension StatisticPresenter: StatisticViewOutput {
    
}
