//
//  LanguagePresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit
import Combine

protocol LanguageViewInput {
    var languages: [Language] { get }
    var language: Language? { get set }
    
    func didSelectItem(indexPath: IndexPath)
    func didTabBackground()
}

protocol LanguageViewOutput {
    var router: LanguageEvent? { get }
    var study: Study? { get set }
    
    func viewDidSelectedLanguage(language: Language)
    func viewDidTapBackground()
    func viewGetStudy()
    func subscribe()
}

class LanguagePresenter: ObservableObject {
    
    @Published var study: Study?
    var router: LanguageEvent?
    var viewInput: (UIViewController & LanguageViewInput)?
    
    private var store = Set<AnyCancellable>()
    
    init(router: LanguageEvent) {
        self.router = router
        getStudy()
    }
    
    private func getStudy() {
        // Get study from core data if exist
        // or create study with local user lang and save to core data
        
        let localLanguageCode = Locale.current.language.languageCode?.identifier ?? "ru"
        let sourceLanguage = Language.language(by: localLanguageCode) ?? .russian
        let targetLanguage: Language = .english == sourceLanguage ? .russian : .english
        
        study = Study(sourceLanguage: sourceLanguage, targerLanguage: targetLanguage)
    }
    
    private func changeStudy(to language: Language) {
        // Сhange study function
        // check for exsist model Study by selected language or create new model Study language
        // Save to core data
    }
    
}

extension LanguagePresenter: LanguageViewOutput {
    
    func subscribe() {
        self.$study
            .receive(on: RunLoop.main)
            .sink { study in
                self.viewInput?.language = study?.targetLanguage
            }
            .store(in: &store)
    }
    
    func viewGetStudy() {
        getStudy()
    }
    
    func viewDidTapBackground() {
        router?.didSendEventClosure?(.close)
    }
    
    func viewDidSelectedLanguage(language: Language) {
        changeStudy(to: language)
        router?.didSendEventClosure?(.change(language: language))
    }
}
