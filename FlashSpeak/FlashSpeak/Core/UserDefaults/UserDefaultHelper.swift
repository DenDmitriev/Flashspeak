//
//  UserDefaultHelper.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 16.04.2023.
//

import Foundation

private enum UserDefaultsKeys: String {
    case nativeLanguage = "nativeLanguageKey"
    case learnQuestionSetting
    case learnAnswerSetting
    case learnLanguageSetting
    
    var asString: String {
        return self.rawValue
    }
}

struct UserDefaultsHelper {
    
    // swiftlint:disable line_length
    
    static var nativeLanguage: String {
        get { UserDefaults.standard
            .object(forKey: UserDefaultsKeys.nativeLanguage.asString) as? String ?? "" }
        set { UserDefaults.standard
            .set(newValue, forKey: UserDefaultsKeys.nativeLanguage.asString) }
    }
    
    static var learnQuestionSetting: Int {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnQuestionSetting.asString) as? Int ?? LearnSettings.Question.word.rawValue
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnQuestionSetting.asString)
            
        }
    }
    
    static var learnAnswerSetting: Int {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnAnswerSetting.asString) as? Int ?? LearnSettings.Answer.test.rawValue
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnAnswerSetting.asString)
            
        }
    }
    
    static var learnLanguageSetting: Int {
        get { UserDefaults.standard
                .object(forKey: UserDefaultsKeys.learnLanguageSetting.asString) as? Int ?? LearnSettings.Language.target.rawValue
        }
        set { UserDefaults.standard
                .set(newValue, forKey: UserDefaultsKeys.learnLanguageSetting.asString)
            
        }
    }
    
    // swiftlint:enable line_length
}
