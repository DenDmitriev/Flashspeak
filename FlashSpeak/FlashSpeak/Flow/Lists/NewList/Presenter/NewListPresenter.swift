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
    func close()
    func newList(title: String, style: GradientStyle, imageFlag: Bool)
}

protocol NewListEvent {
    var didSendEventClosure: ((NewListViewController.Event) -> Void)? { get set }
}

class NewListPresenter {
    
    var viewInput: (UIViewController & NewListViewInput & NewListEvent)?

}

extension NewListPresenter: NewListViewOutput {
    
    func close() {
        viewInput?.didSendEventClosure?(.close)
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
        
        viewInput?.didSendEventClosure?(.close)
        viewInput?.didSendEventClosure?(.done(list: list))
    }
}
