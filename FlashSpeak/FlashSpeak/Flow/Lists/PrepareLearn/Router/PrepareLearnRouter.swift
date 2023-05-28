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
        case close, error(error: LocalizedError), learn(list: List), settings, showCards(list: List)
    }
    
    var didSendEventClosure: ((Action) -> Void)?
}
