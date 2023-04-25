//
//  ListsCoordinator.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

protocol ListsCoordinatorProtocol: Coordinator {
    func showListViewController()
    func showNewList()
    func showListMaker(list: List)
    func showChangeLanguage()
    func showWordCard(list: List)
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
        var listsViewController = ListsBuilder.build()
        listsViewController.navigationItem.title = navigationController.tabBarItem.title
        
        listsViewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .newList:
                self?.showNewList()
            case .changeLanguage:
                self?.showChangeLanguage()
            case .lookList(let list):
                self?.showWordCard(list: list)
            }
        }
        
        navigationController.pushViewController(listsViewController, animated: true)
    }
    
    func showListMaker(list: List) {
        let listMakerController = ListMakerBuilder.build(list: list)
        listMakerController.navigationItem.title = list.title
        
        listMakerController.didSendEventClosure = { [weak self] event in
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        self.navigationController.pushViewController(listMakerController, animated: true)
    }
    
    func showNewList() {
        var newListController = NewListBuilder.build()
        newListController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(newListController, animated: true)
        
        newListController.didSendEventClosure = { [weak self] event in
            switch event {
            case .done(list: let list):
                self?.navigationController.dismiss(animated: true)
                self?.showListMaker(list: list)
            case .close:
                self?.navigationController.dismiss(animated: true)
            }
        }
    }
    
    func showChangeLanguage() {
        var languageController = LanguageBuilder.build()
        languageController.modalPresentationStyle = .overFullScreen
        
        languageController.didSendEventClosure = { event in
            switch event {
            case .close:
                self.navigationController.dismiss(animated: true)
            case .change(let language):
                // TODO: - change user study
                print(#function, language)
                self.navigationController.dismiss(animated: true)
            }
        }
        
        self.navigationController.present(languageController, animated: true)
    }
    
    func showWordCard(list: List) {
        let wordCardsViewController = WordCardsBuilder.build(list: list)
        self.navigationController.pushViewController(wordCardsViewController, animated: true)
    }
}

extension ListsCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        switch childCoordinator.type {
        default:
            break
        }
    }
}
