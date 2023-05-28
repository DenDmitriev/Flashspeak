//
//  AddNewWordPresenter.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 28.05.2023.
//

import Foundation

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
    
    // MARK: Init
    
    init(router: AddNewWordEvent, list: List) {
        self.router = router
        self.list = list
    }
    
    // MARK: Private functions
    
    private func checkIfExists(text: String) -> Bool {
        if let word = list.words.first(where: {
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
}

extension AddNewWordPresenter: AddNewWordOutput {
    
    func saveWord(text: String) {
        guard !checkIfExists(text: text),
              let listCD = coreData.getListObject(by: list.id)
        else { return }
        coreData.createWords([Word(source: text, translation: "")], for: listCD)
        // TODO: Добавить перевод слова
        router?.didSendEventClosure?(.close)
    }
}
