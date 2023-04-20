//
//  ListsCoordinator.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

protocol ListsCoordinatorProtocol: Coordinator {
    func showListViewController()
}

class ListsCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .lists }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        showListViewController()
    }
}

extension ListsCoordinator: ListsCoordinatorProtocol {
    func showListViewController() {
        let listsViewController: ListsViewController = ListsBuilder.build()
        listsViewController.navigationItem.title = navigationController.tabBarItem.title
        
        listsViewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .newList:
                let newListController = NewListBuilder.build()
                newListController.modalPresentationStyle = .overFullScreen
                self?.navigationController.present(newListController, animated: true)
            case .changeLanguage:
                let languageController = LanguageBuilder.build()
                languageController.modalPresentationStyle = .overFullScreen
                self?.navigationController.present(languageController, animated: true)
            case .lookList(let list):
                let wordCardsViewController = WordCardsBuilder.build(list: list)
                self?.navigationController.pushViewController(wordCardsViewController, animated: true)
            }
        }
        
        navigationController.pushViewController(listsViewController, animated: true)
    }
}
