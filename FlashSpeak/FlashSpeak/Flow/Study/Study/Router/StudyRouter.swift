//
//  StudyRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import Foundation

protocol StudyEvent {
    var didSendEventClosure: ((StudyRouter.Event) -> Void)? { get set }
}

struct StudyRouter: StudyEvent {
    
    enum Event {
        case settings, learn(list: List), result(learn: Learn)
    }
    
    var didSendEventClosure: ((Event) -> Void)?
    
}
