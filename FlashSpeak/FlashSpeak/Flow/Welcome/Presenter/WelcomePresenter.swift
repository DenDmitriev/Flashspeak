//
//  WelcomePresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 28.04.2023.
//

import UIKit
import Combine

protocol WelcomeViewInput {
    var presenter: WelcomeViewOutput { get }
    
    func didTabDoneButton()
    func didTabSourceButton()
    func didTabTargetButton()
    func configureButtons(type: Language.LanguageType, language: Language)
    func button(isEnable: Bool)
}

protocol WelcomeViewOutput {
    var router: WelcomeEvent? { get }
    var study: Study { get set }
    var isReady: Bool { get set }
    
    func next()
    func selectSourceLanguage()
    func selectTargetLanguage()
    func subscribe()
    func setLanguage(type: Language.LanguageType, language: Language)
}

class WelcomePresenter: ObservableObject {
    @Published var study: Study
    @Published var isReady: Bool = true
    var router: WelcomeEvent?
    weak var viewController: (UIViewController & WelcomeViewInput)?
    private let coreData = CoreDataManager.instance
    private var store = Set<AnyCancellable>()
    
    init(router: WelcomeEvent) {
        self.router = router
        self.study = WelcomePresenter.createLocalStudy()
    }
    
    // MARK: - Private functions
    
    private static func createLocalStudy() -> Study {
        let sourceLanguage = Language.guessSourceLanguage()
        let targetLanguage = Language.guessTargetLanguage(from: sourceLanguage)
        let study = Study(sourceLanguage: sourceLanguage, targerLanguage: targetLanguage)
        return study
    }
    
    private func saveStudy() {
        saveToUserDefaults(study: study)
        saveToCoreData(study: study)
    }
    
    private func saveToUserDefaults(study: Study) {
        UserDefaultsHelper.nativeLanguage = study.sourceLanguage.code
        UserDefaultsHelper.targetLanguage = study.targetLanguage.code
    }
    
    private func saveToCoreData(study: Study) {
        coreData.createStudy(study)
    }
    
    private func checkForReady() {
        if study.sourceLanguage == study.targetLanguage {
            self.isReady = false
        } else {
            self.isReady = true
        }
    }
}

extension WelcomePresenter: WelcomeViewOutput {
    
    // MARK: - Functions
    
    func next() {
        saveStudy()
        router?.didSendEventClosure?(.complete)
    }
    
    func selectSourceLanguage() {
        router?.didSendEventClosure?(.source(language: study.sourceLanguage))
    }
    
    func selectTargetLanguage() {
        router?.didSendEventClosure?(.target(language: study.targetLanguage))
    }
    
    func subscribe() {
        self.$study
            .receive(on: RunLoop.main)
            .sink { [weak self] study in
                self?.viewController?.configureButtons(type: .source, language: study.sourceLanguage)
                self?.viewController?.configureButtons(type: .target, language: study.targetLanguage)
                self?.checkForReady()
            }
            .store(in: &store)
        
        self.$isReady
            .receive(on: RunLoop.main)
            .sink { isRready in
                self.viewController?.button(isEnable: isRready)
            }
            .store(in: &store)
    }
    
    func setLanguage(type: Language.LanguageType, language: Language) {
        switch type {
        case .source:
            study.sourceLanguage = language
        case .target:
            study.targetLanguage = language
        }
    }
}
