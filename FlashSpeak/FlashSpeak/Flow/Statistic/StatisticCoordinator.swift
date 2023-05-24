//
//  StatisticCoordinator.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//

import UIKit

protocol StatisticCoordinatorProtocol: Coordinator {
    func showStatistic()
}

class StatisticCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .statistic }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        showStatistic()
    }
}

extension StatisticCoordinator: StatisticCoordinatorProtocol {
    func showStatistic() {
        var router = StatisticRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
                // add event case
            }
        }
        
        let statisticViewController = StatisticBuilder.build(router: router)
        statisticViewController.navigationItem.title = NSLocalizedString("Statistics", comment: "Title")
        navigationController.pushViewController(statisticViewController, animated: true)
    }
}
