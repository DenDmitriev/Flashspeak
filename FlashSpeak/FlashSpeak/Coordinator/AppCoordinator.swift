//
//  ApplicationCoordinator.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit
import CoreData

protocol AppCoordinatorProtocol: Coordinator {
    func showMainFlow()
    func showWelcomeFlow()
}

class AppCoordinator: AppCoordinatorProtocol {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    var type: CoordinatorType { .app }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        if
            UserDefaultsHelper.nativeLanguage.isEmpty,
            UserDefaultsHelper.targetLanguage.isEmpty
        {
            showWelcomeFlow()
        } else {
            showMainFlow()
        }
    }
    
    func showMainFlow() {
        let tabCoordinator = TabBarCoordinator(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
    
    func showWelcomeFlow() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController)
        welcomeCoordinator.finishDelegate = self
        welcomeCoordinator.start()
        childCoordinators.append(welcomeCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .tab:
            navigationController.viewControllers.removeAll()
            showWelcomeFlow()
        case .welcome:
            navigationController.viewControllers.removeAll()
            showMainFlow()
        default:
            break
        }
    }
}
