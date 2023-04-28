//
//  WelcomeCoordinator.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 28.04.2023.
//

import UIKit

protocol WelcomeCoordinatorProtocol {
    func showWelcome()
    func showChangeLanguage(type: Language.LanguageType, language: Language)
}

class WelcomeCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .welcome }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        showWelcome()
    }
    
    deinit {
        print("WelcomeCoordinator deinit")
    }
    
}

extension WelcomeCoordinator: WelcomeCoordinatorProtocol {
    
    func showWelcome() {
        var router = WelcomeRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .source(let language):
                self?.showChangeLanguage(type: .source, language: language)
            case .target(let language):
                self?.showChangeLanguage(type: .target, language: language)
            case .complete:
                self?.finish()
            }
        }
        let welcomeViewController = WelcomeBuilder.build(router: router)
//        welcomeViewController.navigationItem.title = "Title"
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
    
    func showChangeLanguage(type: Language.LanguageType, language: Language) {
        var router = LanguageRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .close:
                self?.navigationController.dismiss(animated: true)
            case .change(let language):
                print(#function, language)
                self?.navigationController.dismiss(animated: true)
                self?.updateLanguage(for: type, language: language)
            }
        }
        let languageController = LanguageBuilder.build(router: router, language: language)
        languageController.modalPresentationStyle = .overFullScreen
        self.navigationController.present(languageController, animated: true)
    }
    
    private func updateLanguage(for type: Language.LanguageType, language: Language) {
        guard
            let welcomeViewController = navigationController.viewControllers.first as? WelcomeViewInput
        else { return }
        welcomeViewController.presenter.setLanguage(type: type, language: language)
    }
}
