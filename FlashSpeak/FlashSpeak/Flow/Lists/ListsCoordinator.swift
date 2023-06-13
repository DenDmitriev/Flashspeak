//
//  ListsCoordinator.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//
// swiftlint:disable line_length

import UIKit

protocol ListsCoordinatorProtocol: Coordinator {
    func showListViewController()
    func showNewList(list: List?)
    func showListMaker(list: List)
    func showChangeLanguage(language: Language, description: String?)
    func showWordCard(list: List)
    func showError(error: LocalizedError)
}

class ListsCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .lists }

    var reload: (() -> Void)?
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        showListViewController()
    }
}

extension ListsCoordinator: ListsCoordinatorProtocol {
    
    func showListViewController() {
        let router = ListsRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .prepareLearn(list: let list):
                self?.showPrepareLearn(list: list)
            case .newList:
                self?.showNewList()
            case .changeLanguage(let language):
                self?.showChangeLanguage(language: language)
            case .editList(let list):
                self?.showWordCard(list: list)
            case .error(error: let error):
                self?.showError(error: error)
            case .editWords(list: let list):
                self?.showListMaker(list: list)
            case .transfer(list: let list):
                print(#function, "transfer router", list.title)
            }
        }
        
        let listsViewController = ListsBuilder.build(router: router)
        listsViewController.navigationItem.title = NSLocalizedString("Word Lists", comment: "Title")
        navigationController.pushViewController(listsViewController, animated: true)
    }
    
    func showPrepareLearn(list: List) {
        var router = PrepareLearnRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .close:
                self?.navigationController.dismiss(animated: true)
            case .error(error: let error):
                self?.showError(error: error)
            case .learn(list: let list):
                self?.showLearn(list: list)
            case .showCards(list: let list):
                self?.showWordCard(list: list)
            case .editWords(list: let list):
                self?.showListMaker(list: list)
            case .editCards(list: let list):
                self?.showWordCard(list: list)
            case .showStatistic(list: let list):
                let mistakes = list.words
                    .filter { !$0.learned() }
                    .reduce(into: [Word: String]()) { $0[$1] = "" }
                print(mistakes)
                self?.showResult(list: list, mistakes: mistakes)
            case .showSettings:
                self?.showLearnSettings()
            }
        }
        let prepareLearnViewController = PrepareLearnBuilder.build(router: router, list: list)
        prepareLearnViewController.navigationItem.title = list.title
        self.navigationController.pushViewController(prepareLearnViewController, animated: true)
        self.navigationController.navigationBar.tintColor = UIColor.color(by: list.style)
    }
    
    func showListMaker(list: List) {
        var router = ListMakerRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .generate(let list):
                self?.showWordCard(list: list)
                self?.navigationController.viewControllers.removeAll(where: { $0.isKind(of: ListMakerViewController.self) })
            case .error(let error):
                self?.showError(error: error)
            }
        }
        let listMakerController = ListMakerBuilder.build(list: list, router: router)
        listMakerController.navigationItem.title = list.title
        self.navigationController.pushViewController(listMakerController, animated: true)
        self.navigationController.navigationBar.tintColor = UIColor.color(by: list.style)
    }
    
    func showNewList(list: List? = nil) {
        var router = NewListRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .done(list: let list):
                self?.navigationController.dismiss(animated: true)
                self?.showListMaker(list: list)
            case .close:
                self?.navigationController.dismiss(animated: true)
            }
        }
        let newListController = NewListBuilder.build(router: router, list: list)
        newListController.modalPresentationStyle = .popover
        self.navigationController.present(newListController, animated: true)
    }
    
    func showChangeLanguage(language: Language, description: String? = nil) {
        var router = LanguageRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .close:
                self?.navigationController.dismiss(animated: true)
            case .change(let language):
                self?.navigationController.dismiss(animated: true)
                if UserDefaultsHelper.nativeLanguage != language.code {
                    UserDefaultsHelper.targetLanguage = language.code
                    self?.reload?()
                }
            }
        }
        let description = NSLocalizedString("Select the language of study", comment: "Description")
        let languageController = LanguageBuilder.build(router: router, language: language, description: description)
        languageController.modalPresentationStyle = .popover
        self.navigationController.present(languageController, animated: true)
    }
    
    func showWordCard(list: List) {
        let router = WordCardsRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .word(let word):
                self?.showCard(word: word, style: list.style)
            case .error(error: let error):
                self?.showError(error: error)
            case .edit:
                self?.showListMaker(list: list)
                self?.navigationController.viewControllers.removeAll(where: { $0.isKind(of: WordCardsViewController.self) })
            case .editListProperties(list: let list):
                self?.showNewList(list: list)
            }
        }
        let wordCardsViewController = WordCardsBuilder.build(list: list, router: router)
        self.navigationController.pushViewController(wordCardsViewController, animated: true)
        self.navigationController.navigationBar.tintColor = UIColor.color(by: list.style)
    }

    func showCard(word: Word, style: GradientStyle) {
        var router = CardRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .save(let wordID):
                self?.navigationController.popViewController(animated: true)
                guard
                    let wordID = wordID,
                    let wordCardsViewController = self?.navigationController.viewControllers.last as? WordCardsViewInput,
                    let listsViewController = self?.navigationController.viewControllers.first as? ListsViewInput
                else { return }
                wordCardsViewController.presenter.reloadOriginWord(by: wordID)
                listsViewController.presenter.reloadList()
            case .error(error: let error):
                self?.showError(error: error)
            }
        }
        let cardViewController = CardBuilder.build(word: word, style: style, router: router)
        cardViewController.navigationItem.title = word.source.capitalized
        self.navigationController.pushViewController(cardViewController, animated: true)
        self.navigationController.navigationBar.tintColor = UIColor.color(by: style)
    }
    
    func showLearnSettings() {
        var router = LearnSettingsRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .close:
                self?.navigationController.dismiss(animated: true)
            }
        }
        let viewController = LearnSettingsBuilder.build(router: router)
        viewController.modalPresentationStyle = .popover
        self.navigationController.present(viewController, animated: true)
    }
    
    func showLearn(list: List) {
        var router = LearnRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .complete(let list, let mistakes):
                self?.showResult(list: list, mistakes: mistakes)
                self?.navigationController.viewControllers.removeAll(where: { $0.isKind(of: LearnViewController.self) })
            }
        }
        let viewController = LearnBuilder.build(router: router, list: list)
        viewController.navigationItem.title = list.title
        self.navigationController.pushViewController(viewController, animated: true)
        self.navigationController.navigationBar.tintColor = UIColor.color(by: list.style)
    }
    
    func showResult(list: List, mistakes: [Word: String]) {
        var router = ResultRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .learn:
                self?.showLearn(list: list)
                self?.navigationController.viewControllers.removeAll(where: { $0.isKind(of: ResultViewController.self) })
            case .settings:
                self?.showLearnSettings()
            }
        }
        let viewController = ResultBuilder.build(router: router, list: list, mistakes: mistakes)
        let title = NSLocalizedString("Results", comment: "title")
        viewController.navigationItem.title = title
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func showError(error: LocalizedError) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: "Title"),
            message: error.errorDescription,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: NSLocalizedString("Ok", comment: "Title"),
            style: .default
        )
        alert.addAction(action)
        self.navigationController.present(alert, animated: true)
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
    
    func coordinatorDidReload(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        switch childCoordinator.type {
        default:
            break
        }
    }
}

// swiftlint:enable line_length
