//
//  StatisticRouter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//

import Foundation

protocol StatisticEvent {
    var didSendEventClosure: ((StatisticRouter.Event) -> Void)? { get set }
}

struct StatisticRouter: StatisticEvent {
    enum Event {
        
    }
    
    var didSendEventClosure: ((Event) -> Void)?
}
