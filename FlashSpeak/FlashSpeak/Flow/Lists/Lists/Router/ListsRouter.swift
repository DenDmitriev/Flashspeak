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
        case newList, changeLanguage(language: Language), lookList(list: List)
    }
    
    var didSendEventClosure: ((ListsRouter.Event) -> Void)?
}
