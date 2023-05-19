//
//  LearnManagerError.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 12.05.2023.
//

import Foundation

enum LearnManagerError: LocalizedError {
    case imageLoad(word: Word)
    
    var errorDescription: String {
        switch self {
        case .imageLoad(let word):
            return NSLocalizedString("Image load error" , comment: "Error") + word.source
        }
    }
}
