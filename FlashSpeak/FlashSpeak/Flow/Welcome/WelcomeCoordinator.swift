//
//  WelcomeCoordinator.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 28.04.2023.
//

import UIKit

protocol WelcomeCoordinatorProtocol {
    func showWelcome()
    func showChangeLanguage(type: Language.LanguageType, language: Language, description: String?)
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
    
}

extension WelcomeCoordinator: WelcomeCoordinatorProtocol {
    
    func showWelcome() {
        var router = WelcomeRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .source(let language):
                let description = NSLocalizedString("Select your native language", comment: "Description")
                self?.showChangeLanguage(type: .source, language: language, description: description)
            case .target(let language):
                let description = NSLocalizedString("Select the language of study", comment: "Description")
                self?.showChangeLanguage(type: .target, language: language, description: description)
            case .complete:
                self?.finish()
            }
        }
        let welcomeViewController = WelcomeBuilder.build(router: router)
//        welcomeViewController.navigationItem.title = "Title"
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
    
    func showChangeLanguage(type: Language.LanguageType, language: Language, description: String? = nil) {
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
        let languageController = LanguageBuilder.build(
            router: router,
            language: language,
            description: description
        )
        languageController.modalPresentationStyle = .popover
        self.navigationController.present(languageController, animated: true)
    }
    
    private func updateLanguage(for type: Language.LanguageType, language: Language) {
        guard
            let welcomeViewController = navigationController.viewControllers.first as? WelcomeViewInput
        else { return }
        welcomeViewController.presenter.setLanguage(type: type, language: language)
    }
}
