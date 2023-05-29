//
//  AddNewWordRouter.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 28.05.2023.
//

import Foundation

protocol AddNewWordEvent {
    var didSendEventClosure: ((AddNewWordRouter.Event) -> Void)? { get set }
}

struct AddNewWordRouter: AddNewWordEvent {
    
    enum Event {
        case close
    }
    
    var didSendEventClosure: ((Event) -> Void)?
}
