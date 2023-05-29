//
//  PrepareLearnRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import Foundation

protocol PrepareLearnEvent {
    var didSendEventClosure: ((PrepareLearnRouter.Action) -> Void)? { get set }
}

struct PrepareLearnRouter: PrepareLearnEvent {
    
    enum Action {
        case close
        case error(error: LocalizedError)
        case learn(list: List)
        case editWords(list: List)
        case editCards(list: List)
    }
    
    var didSendEventClosure: ((Action) -> Void)?
}
