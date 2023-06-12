//
//  LearnLanguage.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation
import UIKit.UIImage

class LearnLanguage: LearnSettingProtocol {
    typealias Setting = Language
    
    enum Language: Int, TitleImageable {
        case source, target
        
        var title: String {
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
            return nil
        }
    }
    
    var active: Language
    
    var all: [Language] {
        Setting.allCases
    }
    
    var title: String
    
    var value: Int?
    
    var controller: LearnSettingControl
    
    weak var delegate: LearnSettingsDelegate?
    
    init(delegate: LearnSettingsDelegate?) {
        self.active = LearnLanguage.fromUserDefaults()
        self.title = NSLocalizedString("Language", comment: "Title")
        self.controller = .selector
        self.delegate = delegate
    }
    
    static func fromUserDefaults() -> Language {
        return Language(rawValue: UserDefaultsHelper.learnLanguageSetting) ?? .target
    }
    
    func saveToUserDefaults(with value: Int?) {
        UserDefaultsHelper.learnLanguageSetting = active.rawValue
    }
    
    func changed<T>(controlValue: T) {
        guard let index = controlValue as? Int else { return }
        switch index {
        case Language.source.rawValue:
            active = .source
        case Language.target.rawValue:
            active = .target
        default:
            return
        }
        self.saveToUserDefaults(with: value)
    }
    
    func getControlValue<T>() -> T? {
        guard let controlValue = active.rawValue as? T else { return nil }
        return controlValue
    }
}


