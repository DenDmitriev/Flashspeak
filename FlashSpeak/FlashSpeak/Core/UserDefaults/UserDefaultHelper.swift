//
//  UserDefaultHelper.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 16.04.2023.
//

import Foundation

fileprivate enum UserDefaultsKeys: String {
    case nativeLanguage = "nativeLanguageKey"
    
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
}
