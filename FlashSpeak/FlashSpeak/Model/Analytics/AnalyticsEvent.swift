//
//  AnalyticsEvent.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 24.06.2024.
//

import Foundation

enum AnalyticsEvent: String {
    case selectLanguage
    case startLearn
    case createList
    
    var key: String {
        self.rawValue
    }
}
