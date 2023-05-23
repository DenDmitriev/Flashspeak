//
//  Language.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.04.2023.
//

import UIKit

enum Language: Int, CaseIterable {
    enum LanguageType {
        case source, target
    }
    
    case russian = 0
    case english = 1
    case german = 2
    case french = 3
    case spanish = 4
    case portuguese = 5
    
    /// Code by ISO 639
    var code: String {
        let code: String
        switch self {
        case .english:
            code = "en"
        case .spanish:
            code = "es"
        case .french:
            code = "fr"
        case .russian:
            code = "ru"
        case .portuguese:
            code = "pt"
        case .german:
            code = "de"
        }
        return code
    }
    
    /// Language name
    var description: String {
        let name: String
        switch self {
        case .english:
            name = NSLocalizedString("English", comment: "Button")
        case .spanish:
            name = NSLocalizedString("Spanish", comment: "Button")
        case .french:
            name = NSLocalizedString("French", comment: "Button")
        case .russian:
            name = NSLocalizedString("Russian", comment: "Button")
        case .portuguese:
            name = NSLocalizedString("Portuguese", comment: "Button")
        case .german:
            name = NSLocalizedString("German", comment: "Button")
        }
        
        return NSLocalizedString(name.capitalized, comment: "language")
    }
    
    /// Get Language by code
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
    
    static func guessSourceLanguage() -> Language {
        let localLanguageCode = Locale.current.language.languageCode?.identifier ?? "ru"
        let sourceLanguage = Language.language(by: localLanguageCode) ?? .russian
        return sourceLanguage
    }
    
    static func guessTargetLanguage(from: Language) -> Language {
        switch from {
        case .russian:
            return .english
        case .english:
            return .french
        case .german:
            return .english
        case .french:
            return .english
        case .spanish:
            return .english
        case .portuguese:
            return .english
        }
    }
    
    func icon() -> UIImage {
        let image: UIImage?
        switch self {
        case .russian:
            image = UIImage(named: "lang.icon.ru")
        case .english:
            image = UIImage(named: "lang.icon.en")
        case .german:
            image = UIImage(named: "lang.icon.de")
        case .french:
            image = UIImage(named: "lang.icon.fr")
        case .spanish:
            image = UIImage(named: "lang.icon.es")
        case .portuguese:
            image = UIImage(named: "lang.icon.pt")
        }
        return image ?? UIImage(systemName: "questionmark.app.fill") ?? UIImage()
    }
}
