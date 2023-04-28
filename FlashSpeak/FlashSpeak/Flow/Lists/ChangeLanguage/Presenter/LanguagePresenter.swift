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
    var language: Language? { get set }
    
    func viewDidSelectedLanguage(language: Language)
    func viewDidTapBackground()
    func subscribe()
}

class LanguagePresenter: ObservableObject {
    
    @Published var language: Language?
    var router: LanguageEvent?
    weak var viewInput: (UIViewController & LanguageViewInput)?
    
    private var store = Set<AnyCancellable>()
    
    init(router: LanguageEvent, language: Language) {
        self.router = router
        self.language = language
    }
    
    private func getLocalLanguage() {
        let localLanguageCode = Locale.current.language.languageCode?.identifier ?? "ru"
        let sourceLanguage = Language.language(by: localLanguageCode) ?? .russian
        language = sourceLanguage
    }
    
    private func changeStudy(to language: Language) {
        // Сhange study function
        // check for exsist model Study by selected language or create new model Study language
        // Save to core data
    }
    
}

extension LanguagePresenter: LanguageViewOutput {
    
    func subscribe() {
        self.$language
            .receive(on: RunLoop.main)
            .sink { language in
                self.viewInput?.language = language
            }
            .store(in: &store)
    }
    
    func viewDidTapBackground() {
        router?.didSendEventClosure?(.close)
    }
    
    func viewDidSelectedLanguage(language: Language) {
        changeStudy(to: language)
        router?.didSendEventClosure?(.change(language: language))
    }
}
