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
    
    var type: CoordinatorType { .lists }
    
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
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.prefersLargeTitles = true
        let listsCoordinator = ListsCoordinator(navigationController)
        listsCoordinator.finishDelegate = self
        listsCoordinator.start()
        listsCoordinator.reload = {
            listsCoordinator.reload()
        }
        childCoordinators.append(listsCoordinator)
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
        case .lists:
            navigationController.viewControllers.removeAll()
            showWelcomeFlow()
        case .welcome:
            navigationController.viewControllers.removeAll()
            showMainFlow()
        default:
            break
        }
    }
    
    func coordinatorDidReload(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        navigationController.viewControllers.removeAll()
        switch childCoordinator.type {
        case .lists:
            showMainFlow()
        case .welcome:
            showWelcomeFlow()
        default:
            break
        }
    }
}
