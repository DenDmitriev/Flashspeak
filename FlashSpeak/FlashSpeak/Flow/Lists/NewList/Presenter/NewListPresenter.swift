//
//  NewListPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit
import Combine

protocol NewListViewInput {
    var styles: [GradientStyle] { get }
    var viewModel: ListViewModel { get set }
    
    func createList(_ viewModel: ListViewModel?)
    func selectStyle(_ style: GradientStyle)
}

protocol NewListViewOutput {
    
    var router: NewListEvent? { get set }
    
    func close()
    func isChanged(_ viewModel: ListViewModel) -> Bool?
    func presentList(_ viewModel: ListViewModel?)
}

class NewListPresenter {
    
    weak var viewInput: (UIViewController & NewListViewInput)?
    var router: NewListEvent?
    var list: List?
    
    init(router: NewListEvent, list: List? = nil) {
        self.router = router
        self.list = list
    }
    
    private func newList(_ viewModel: ListViewModel) {
        let list = List(
            title: viewModel.title,
            words: [],
            style: viewModel.style,
            created: Date.now,
            addImageFlag: viewModel.imageFlag,
            learns: []
        )
        router?.didSendEventClosure?(.done(list: list))
    }
    
    private func editList(_ viewModel: ListViewModel) {
        list?.title = viewModel.title
        list?.style = viewModel.style
        list?.addImageFlag = viewModel.imageFlag
        if let list = list {
            CoreDataManager.instance.updateList(list)
        }
        router?.didSendEventClosure?(.close)
    }
    
}

extension NewListPresenter: NewListViewOutput {
    
    func close() {
        router?.didSendEventClosure?(.close)
    }
    
    func presentList(_ viewModel: ListViewModel?) {
        guard let viewModel = viewModel else { return }
        if list == nil {
            newList(viewModel)
        } else {
            editList(viewModel)
        }
    }
    
    func isChanged(_ viewModel: ListViewModel) -> Bool? {
        return viewModel.isEquals(list: list)
    }
}
