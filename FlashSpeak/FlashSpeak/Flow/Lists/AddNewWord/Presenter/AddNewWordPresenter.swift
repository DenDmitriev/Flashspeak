//
//  AddNewWordPresenter.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 28.05.2023.
//

import Foundation
import Combine

protocol AddNewWordInput {
    func showAlert(with text: String)
}

protocol AddNewWordOutput {
    func saveWord(text: String)
}

class AddNewWordPresenter {
    
    var controllerDelegate: AddNewWordInput?
    
    // MARK: Private properties
    
    private let router: AddNewWordEvent?
    private let list: List
    private let coreData = CoreDataManager.instance
    private var cancellables = Set<AnyCancellable>()
    private var word: Word?
    
    // MARK: Init
    
    init(router: AddNewWordEvent, list: List) {
        self.router = router
        self.list = list
    }
    
    // MARK: Private functions
    
    private func checkIfExists(text: String) -> Bool {
        if let _ = list.words.first(where: {
            $0.source.lowercased() == text.lowercased()
        }) {
            controllerDelegate?.showAlert(
                with: NSLocalizedString(
                    "This word has already been added",
                    comment: "Errors"
                )
            )
            return true
        } else {
            return false
        }
    }
    
    private func getTranslateWords(words: [String],
                                   source: Language,
                                   target: Language) {
        guard
            let url = URLConfiguration.shared.translateURL(
                words: words,
                targetLang: target,
                sourceLang: source
            )
        else { return }
        NetworkService().translateWords(url: url)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    let error = ListMakerError.loadTransalte(error: error)
                    self?.controllerDelegate?.showAlert(
                        with: error.errorDescription
                    )
                case .finished:
                    self?.complete()
                }
            }, receiveValue: { [self] translated in
                if let transWord = translated.translatedWord.first {
                    word = Word(
                        source: transWord.sourceWords.text,
                        translation: transWord.translations.text
                    )
                }
            })
            .store(in: &cancellables)
    }
    
    private func complete() {
        if let word = word,
           let listCD = coreData.getListObject(by: list.id) {
            coreData.createWords([word], for: listCD)
            router?.didSendEventClosure?(.close)
        }
    }
}

extension AddNewWordPresenter: AddNewWordOutput {
    
    func saveWord(text: String) {
        guard !checkIfExists(text: text),
              let listCD = coreData.getListObject(by: list.id),
              let studyCD = listCD.studyCD
        else { return }
        let study = Study(studyCD: studyCD)
        getTranslateWords(
            words: [text],
            source: study.sourceLanguage,
            target: study.targetLanguage
        )
    }
}
