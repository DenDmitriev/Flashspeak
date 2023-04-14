//
//  Language.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.04.2023.
//

import Foundation

enum Language: String, CaseIterable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case russian = "ru"
    case portuguese = "pt"
    case german = "de"
    
    ///Code by ISO 639
    var code: String {
        return self.rawValue
    }
    
    ///Language name
    var description: String {
        let name: String
        switch self {
        case .english:
            name = "english"
        case .spanish:
            name = "spanish"
        case .french:
            name = "french"
        case .russian:
            name = "russian"
        case .portuguese:
            name = "portuguese"
        case .german:
            name = "german"
        }
        
        return NSLocalizedString(name.capitalized, comment: "language")
    }
    
    ///Get Language by code
    static func language(by code: String) -> Self? {
        switch code {
        case "en":
            return Self.english
        case "es":
            return Self.spanish
        case "fr":
            return Self.french
        case "ru":
            return Self.russian
        case "pt":
            return Self.portuguese
        case "de":
            return Self.german
        default:
            return nil
        }
    }
}
