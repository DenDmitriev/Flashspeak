//
//  NewListPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit
import Combine

protocol NewListViewInput {
    var styleList: GradientStyle? { get set }
    
    func createList(title: String, style: GradientStyle, imageFlag: Bool)
    func selectStyle(_ style: GradientStyle)
}

protocol NewListViewOutput {
    
    var router: NewListEvent? { get set }
    
    func close()
    func newList(title: String, style: GradientStyle, imageFlag: Bool)
}

class NewListPresenter {
    
    var viewInput: (UIViewController & NewListViewInput)?
    var router: NewListEvent?
    
    init(router: NewListEvent) {
        self.router = router
    }
}

extension NewListPresenter: NewListViewOutput {
    
    func close() {
        router?.didSendEventClosure?(.close)
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
        
        router?.didSendEventClosure?(.close)
        router?.didSendEventClosure?(.done(list: list))
    }
}
