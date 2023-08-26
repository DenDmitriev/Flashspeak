//
//  WelcomeRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 28.04.2023.
//

import Foundation

protocol WelcomeEvent {
    var didSendEventClosure: ((WelcomeRouter.Event) -> Void)? { get set }
}

struct WelcomeRouter: WelcomeEvent {
    
    enum Event {
        case complete, source(language: Language), target(language: Language)
    }
    
    var didSendEventClosure: ((Event) -> Void)?
}
