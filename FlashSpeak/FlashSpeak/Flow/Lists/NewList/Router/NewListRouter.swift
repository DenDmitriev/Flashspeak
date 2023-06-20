//
//  NewListRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 26.04.2023.
//

import Foundation

protocol NewListEvent {
    var didSendEventClosure: ((NewListRouter.Event) -> Void)? { get set }
}

struct NewListRouter: NewListEvent {
    enum Event {
        case done(list: List), close
    }
    
    var didSendEventClosure: ((Event) -> Void)?
}
