//
//  UserDefaultHelper.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 16.04.2023.
//
// swiftlint:disable line_length

import Foundation

private enum UserDefaultsKeys: String {
    case nativeLanguage = "nativeLanguageKey"
    case targetLenguage = "targetLanguageKey"
    
    case learnModeSetting
    case learnModeTimerSetting
    case learnWordSetting
    case learnImageSetting
    case learnSoundSetting
    case learnAnswerSetting
    case learnLanguageSetting
    
    var asString: String {
        return self.rawValue
    }
}

struct UserDefaultsHelper {
    
    static var nativeLanguage: String {
        get { UserDefaults.standard
            .object(forKey: UserDefaultsKeys.nativeLanguage.asString) as? String ?? "" }
        set { UserDefaults.standard
            .set(newValue, forKey: UserDefaultsKeys.nativeLanguage.asString) }
    }
    
    static func source() -> Language? {
        Language.language(by: self.nativeLanguage)
    }
    
    static var targetLanguage: String {
        get { UserDefaults.standard
            .object(forKey: UserDefaultsKeys.targetLenguage.asString) as? String ?? "" }
        set { UserDefaults.standard
            .set(newValue, forKey: UserDefaultsKeys.targetLenguage.asString)
        }
    }
    
    static func target() -> Language? {
        Language.language(by: self.targetLanguage)
    }
    
    // MARK: - Learn Settings
    
    // MARK: Mode Settings
    static var learnModeSetting: Int {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnModeSetting.asString) as? Int ?? .zero
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnModeSetting.asString)
        }
    }
    
    static var learnModeTimerSetting: Int {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnModeTimerSetting.asString) as? Int ?? 60 // initial 60 seconds
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnModeTimerSetting.asString)
        }
    }
    
    // MARK: Question Settings
    static var learnWordSetting: Bool {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnWordSetting.asString) as? Bool ?? true
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnWordSetting.asString)
            
        }
    }
    
    static var learnImageSetting: Bool {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnImageSetting.asString) as? Bool ?? true
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnImageSetting.asString)
        }
    }
    
    static var learnSoundSetting: Bool {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnSoundSetting.asString) as? Bool ?? true
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnSoundSetting.asString)
        }
    }
    
    // MARK: Answer Settings
    static var learnAnswerSetting: Int {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnAnswerSetting.asString) as? Int ?? LearnAnswer.Answer.test.rawValue
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnAnswerSetting.asString)
        }
    }
    
    // MARK: Language Learn Settings
    static var learnLanguageSetting: Int {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnLanguageSetting.asString) as? Int ?? LearnLanguage.Language.target.rawValue
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnLanguageSetting.asString)
        }
    }
}

// swiftlint:enable line_length
