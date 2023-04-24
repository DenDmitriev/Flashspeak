//
//  ListsPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//

import UIKit

protocol ListsViewInput {
    var lists: [List] { get set }
    func didSelectList(index: Int)
    func didTapLanguage()
    func didTapNewList()
}

protocol ListsViewOutput {
    func getLists()
}

class ListsPresenter {
    
    var viewController: ListsViewController?
}

extension ListsPresenter: ListsViewOutput {
    
    func getLists() {
        print(#function)
        //get core data study & lists here
        //send lists to controller viewInput?.lists
    }
}
