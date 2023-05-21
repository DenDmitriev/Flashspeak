//
//  LearnSettingsRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import Foundation

protocol LearnSettingsEvent {
    var didSendEventClosure: ((LearnSettingsRouter.Event) -> Void)? { get set }
}

struct LearnSettingsRouter: LearnSettingsEvent {
    
    enum Event {
        case close
    }
    
    var didSendEventClosure: ((Event) -> Void)?
}
