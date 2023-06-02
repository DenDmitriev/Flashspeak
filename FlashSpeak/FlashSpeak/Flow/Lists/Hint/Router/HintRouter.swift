//
//  HintRouter.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 22.05.2023.
//

import Foundation

protocol HintEvent {
    var didSendEventClosure: ((HintRouter.Event) -> Void)? { get set }
}

struct HintRouter: HintEvent {
    
    enum Event {
        case close
    }
    
    var didSendEventClosure: ((Event) -> Void)?
}
