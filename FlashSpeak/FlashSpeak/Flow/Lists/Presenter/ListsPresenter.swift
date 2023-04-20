//
//  ListsPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//

import UIKit

protocol ListsViewInput {
    var lists: [List] { get set }
    func getLists()
    func didSelectList(index: Int)
    func didTapNewList()
    func didTapLanguage()
}

protocol ListsViewOutput {
    func viewGetLists()
    func showNewListController()
    func showLanguageController()
    func showWordCards(list: List)
}

class ListsPresenter {
    
    var viewInput: (UIViewController & ListsViewInput)?
    
    private func getLists() {
        //get core data study & lists here
        //send lists to controller viewInput?.lists
    }
}

extension ListsPresenter: ListsViewOutput {
    
    func viewGetLists() {
        self.getLists()
    }
    
    func showNewListController() {
        let newListController = NewListBuilder.build()
        newListController.modalPresentationStyle = .overFullScreen
        viewInput?.present(newListController, animated: true)
    }
    
    func showLanguageController() {
        let languageController = LanguageBuilder.build()
        languageController.modalPresentationStyle = .overFullScreen
        viewInput?.present(languageController, animated: true)
    }
    
    func showWordCards(list: List) {
        let wordCardsViewController = WordCardsBuilder.build(list: list)
        viewInput?.navigationController?.pushViewController(wordCardsViewController, animated: true)
    }
}
