//
//  LanguagePresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

protocol LanguageViewInput {
    var study: Study? { get set }
    func didSelectItem(index: Int)
    func getStudy()
    func dissmisView()
}

protocol LanguageViewOutput {
    func viewGetStudy()
    func changeStudyLanguage(language: Language)
    func close()
}

class LanguagePresenter {
    
    var viewInput: (UIViewController & LanguageViewInput)?
    
    private func currentStudy() {
        let localLanguageCode = Locale.current.language.languageCode?.identifier ?? "ru"
        let sourceLanguage = Language.language(by: localLanguageCode) ?? .russian
        let targetLanguage: Language = .english == sourceLanguage ? .russian : .english
        
        viewInput?.study = Study(sourceLanguage: sourceLanguage, targerLanguage: targetLanguage)
    }
    
    private func changeStudy(to language: Language) {
        // check for exsist model Study by selected language or create new model Study language
        // Save to core data
        // update loading app key study
        
        // Change user study course here
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.viewInput?.dismiss(animated: true)
        }
    }
    
}

extension LanguagePresenter: LanguageViewOutput {
    
    func close() {
        viewInput?.dismiss(animated: true)
    }
    
    func viewGetStudy() {
        self.currentStudy()
    }
    
    func changeStudyLanguage(language: Language) {
        self.changeStudy(to: language)
    }
}
