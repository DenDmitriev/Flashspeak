//
//  ListMakerRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 26.04.2023.
//

import Foundation

protocol ListMakerEvent {
    var didSendEventClosure: ((ListMakerRouter.Event) -> Void)? { get set }
}

struct ListMakerRouter: ListMakerEvent {
    
    enum Event {
        case generate(list: List), error(error: LocalizedError)
    }
    
    var didSendEventClosure: ((Event) -> Void)?
}
