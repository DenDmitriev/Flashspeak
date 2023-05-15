//
//  CardRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import Foundation

protocol CardEvent {
    var didSendEventClosure: ((CardRouter.Event) -> Void)? { get set }
}

struct CardRouter: CardEvent {
    enum Event {
        case close, error(error: LocalizedError)
    }
    
    var didSendEventClosure: ((Event) -> Void)?
}
