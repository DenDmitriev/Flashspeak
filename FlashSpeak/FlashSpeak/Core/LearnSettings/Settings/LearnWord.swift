//
//  LearnWord.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation
import UIKit.UIImage

class LearnWord: LearnSettingProtocol {
    
    typealias Setting = Word
    
    enum Word: Int, TitleImageable {
        case word, noWord
        
        var title: String {
            switch self {
            case .word:
                return NSLocalizedString("Word", comment: "Title")
            case .noWord:
                return NSLocalizedString("Empty", comment: "Title")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .word:
                return UIImage(systemName: "character")
            case .noWord:
                return nil
            }
        }
    }
    
    var active: Word
    
    var all: [Word] {
        Setting.allCases
    }
    
    var title: String
    
    var image: UIImage?
    
    var value: Int?
    
    var controller: LearnSettingControl
    
    weak var delegate: LearnSettingsDelegate?
    
    init(delegate: LearnSettingsDelegate?) {
        self.active = LearnWord.fromUserDefaults()
        self.image = UIImage(systemName: "character")
        self.title = NSLocalizedString("Word", comment: "Title")
        self.controller = .switcher
        self.delegate = delegate
    }
    
    static func fromUserDefaults() -> Word {
        if UserDefaultsHelper.learnWordSetting {
            return .word
        } else {
            return .noWord
        }
    }
    
    func saveToUserDefaults(with value: Int?) {
        switch active {
        case .word:
            UserDefaultsHelper.learnWordSetting = true
        case .noWord:
            UserDefaultsHelper.learnWordSetting = false
        }
    }
    
    func changed<T>(controlValue: T) {
        guard let isOn = controlValue as? Bool else { return }
        if isOn {
            active = .word
        } else {
            active = .noWord
        }
        self.saveToUserDefaults(with: value)
    }
    
    func getControlValue<T>() -> T? {
        let value = active == .word ? true : false
        guard let controlValue = value as? T else { return nil }
        return controlValue
    }
}
