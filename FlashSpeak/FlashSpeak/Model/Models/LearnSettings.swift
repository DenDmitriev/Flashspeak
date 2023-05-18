//
//  LearnSettings.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import UIKit

protocol Settingable {
    var name: String { get }
    var image: UIImage? { get }
}

struct LearnSettings {
    var question: Question
    var answer: Answer
    var language: Language
    
    init(question: Int, answer: Int, language: Int) {
        self.question = Question.allCases.first(where: { $0.rawValue == question }) ?? Question.word
        self.answer = Answer.allCases.first(where: { $0.rawValue == answer }) ?? Answer.test
        self.language = Language.allCases.first(where: { $0.rawValue == language }) ?? Language.target
    }
    
    enum Settings: Int, CaseIterable {
        case question, answer, language
        
        var name: String {
            switch self {
            case .question:
                return NSLocalizedString("Вид карточек", comment: "Title")
            case .answer:
                return NSLocalizedString("Вид ответа", comment: "Title")
            case .language:
                return NSLocalizedString("Язык карточки", comment: "Title")
            }
        }
        
        var description: String {
            switch self {
            case .question:
                return NSLocalizedString("Выберите способ показа вопроса", comment: "Description")
            case .answer:
                return NSLocalizedString("Выберите способ ответа", comment: "Description")
            case .language:
                return NSLocalizedString("Выберите язык вопроса", comment: "Description")
            }
        }
    }
    
    enum Question: Int, CaseIterable, Settingable {
        
        case word, image, wordImage
        
        static func fromRawValue(index: Int) -> Question {
            return Question(rawValue: index) ?? .word
        }
        
        var name: String {
            switch self {
            case .word:
                return NSLocalizedString("Word", comment: "Title")
            case .image:
                return NSLocalizedString("Image", comment: "Title")
            case .wordImage:
                return NSLocalizedString("Word and Image", comment: "Title")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .word:
                return UIImage(systemName: "character")
            case .image:
                return UIImage(systemName: "photo")
            case .wordImage:
                return UIImage(systemName: "doc.richtext.fill")
            }
        }
    }
    
    enum Answer: Int, CaseIterable, Settingable {
        case test, keyboard
        
        static func fromRawValue(index: Int) -> Answer {
            return Answer(rawValue: index) ?? .test
        }
        
        var name: String {
            switch self {
            case .test:
                return NSLocalizedString("Test", comment: "Title")
            case .keyboard:
                return NSLocalizedString("Keyboard", comment: "Title")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .test:
                return UIImage(systemName: "square.grid.2x2.fill")
            case .keyboard:
                return UIImage(systemName: "keyboard.fill")
            }
        }
    }
    
    enum Language: Int, CaseIterable, Settingable {
        case source, target
        
        static func fromRawValue(index: Int) -> Language {
            return Language(rawValue: index) ?? .target
        }
        
        var name: String {
            let code: String
            switch self {
            case .source:
                code = UserDefaultsHelper.nativeLanguage
            case .target:
                code = UserDefaultsHelper.targetLanguage
            }
            let language = FlashSpeak.Language.language(by: code)
            return language?.description.capitalized ?? code.uppercased()
        }
        
        var image: UIImage? {
            let code: String
            switch self {
            case .source:
                code = UserDefaultsHelper.nativeLanguage
            case .target:
                code = UserDefaultsHelper.targetLanguage
            }
            let language = FlashSpeak.Language.language(by: code)
            return language?.icon()
        }
    }
}
