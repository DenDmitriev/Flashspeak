//
//  LearnSettings.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation

enum LearnSettings: Int, CaseIterable {
    case mode, question, answer
    
    var title: String {
        switch self {
        case .mode:
            return NSLocalizedString("Mode", comment: "Title")
        case .question:
            return NSLocalizedString("Question mode", comment: "Title")
        case .answer:
            return NSLocalizedString("Answer mode", comment: "Title")
        }
    }
}
