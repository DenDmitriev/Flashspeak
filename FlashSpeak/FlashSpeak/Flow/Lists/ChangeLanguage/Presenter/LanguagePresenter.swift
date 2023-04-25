//
//  LanguagePresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

protocol LanguageViewInput {
    var study: Study? { get set }
    var languages: [Language] { get }
    
    func didSelectItem(indexPath: IndexPath)
}

protocol LanguageViewOutput {
    func viewDidSelectedLanguage(language: Language)
    func viewDidTapBackground()
    func viewGetStudy()
}

protocol LanguageEvent {
    var didSendEventClosure: ((LanguageController.Event) -> Void)? { get set }
}

class LanguagePresenter {
    
    var viewInput: (UIViewController & LanguageViewInput & LanguageEvent)?
    
    private func getStudy() {
        // Get study from core data if exist
        // or create study with local user lang and save to core data
        
        let localLanguageCode = Locale.current.language.languageCode?.identifier ?? "ru"
        let sourceLanguage = Language.language(by: localLanguageCode) ?? .russian
        let targetLanguage: Language = .english == sourceLanguage ? .russian : .english
        
        viewInput?.study = Study(sourceLanguage: sourceLanguage, targerLanguage: targetLanguage)
    }
    
    private func changeStudy(to language: Language) {
        // Сhange study function
        // check for exsist model Study by selected language or create new model Study language
        // Save to core data
    }
    
}

extension LanguagePresenter: LanguageViewOutput {
    
    func viewGetStudy() {
        getStudy()
    }
    
    func viewDidTapBackground() {
        viewInput?.didSendEventClosure?(.close)
    }
    
    func viewDidSelectedLanguage(language: Language) {
        changeStudy(to: language)
        viewInput?.didSendEventClosure?(.change(language: language))
    }
}
