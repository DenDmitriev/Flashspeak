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
            return NSLocalizedString("Lesson Mode", comment: "Title")
        case .question:
            return NSLocalizedString("Question Mode", comment: "Title")
        case .answer:
            return NSLocalizedString("Answer Mode", comment: "Title")
        }
    }
}
