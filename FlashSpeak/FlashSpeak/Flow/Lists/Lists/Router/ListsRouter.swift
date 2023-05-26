//
//  ListsRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.04.2023.
//

import Foundation

protocol ListsEvent {
    var didSendEventClosure: ((ListsRouter.Event) -> Void)? { get set }
}

class ListsRouter: ListsEvent {
    
    enum Event {
        case prepareLearn(list: List)
        case newList
        case changeLanguage(language: Language)
        case editList(list: List)
        case editWords(list: List)
        case transfer(list: List)
        case error(error: LocalizedError)
    }
    
    var didSendEventClosure: ((ListsRouter.Event) -> Void)?
}
