//
//  NewListPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

protocol NewListViewInput {
    var styleList: GradientStyle? { get set }
    func dismissView()
    func createList(title: String, style: GradientStyle, imageFlag: Bool)
    var didSendEventClosure: ((NewListViewController.Event) -> Void)? { get set }
    func selectStyle(_ style: GradientStyle)
}

protocol NewListViewOutput {
    func close()
    func newList(title: String, style: GradientStyle, imageFlag: Bool)
}

class NewListPresenter {
    
    var viewInput: (UIViewController & NewListViewInput)?
}

extension NewListPresenter: NewListViewOutput {
    
    func close() {
        viewInput?.dismiss(animated: true)
    }
    
    func newList(title: String, style: GradientStyle, imageFlag: Bool) {
        let list = List(
            title: title,
            words: [],
            style: style,
            created: Date.now,
            addImageFlag: imageFlag
        )
        print(#function, list)
        viewInput?.dismiss(animated: true)
        viewInput?.didSendEventClosure?(.done(list: list))
    }
}
