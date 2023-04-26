//
//  LanguageRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 26.04.2023.
//

import Foundation

protocol LanguageEvent {
    
    var didSendEventClosure: ((LanguageRouter.Event) -> Void)? { get set }
}

struct LanguageRouter: LanguageEvent {
    
    enum Event {
        case change(language: Language)
        case close
    }
    
    var didSendEventClosure: ((Event) -> Void)?
}
