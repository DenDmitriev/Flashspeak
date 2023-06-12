//
//  LearnSound.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation
import UIKit.UIImage

class LearnSound: LearnSettingProtocol {
    
    typealias Setting = Sound
    
    enum Sound: Int, TitleImageable {
        case sound, noSound
        
        var title: String {
            switch self {
            case .sound:
                return NSLocalizedString("Speaker", comment: "Title")
            case .noSound:
                return NSLocalizedString("Empty", comment: "Title")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .sound:
                return UIImage(systemName: "speaker")
            case .noSound:
                return nil
            }
        }
    }
    
    var active: Sound
    
    var all: [Sound] {
        Setting.allCases
    }
    
    var title: String
    
    var value: Int?
    
    var controller: LearnSettingControl
    
    weak var delegate: LearnSettingsDelegate?
    
    init(delegate: LearnSettingsDelegate?) {
        self.active = LearnSound.fromUserDefaults()
        self.title = NSLocalizedString("Sound", comment: "Title")
        self.controller = .switcher
        self.delegate = delegate
    }
    
    static func fromUserDefaults() -> Sound {
        if UserDefaultsHelper.learnSoundSetting {
            return .sound
        } else {
            return .noSound
        }
    }
    
    func saveToUserDefaults(with value: Int?) {
        switch active {
        case .sound:
            UserDefaultsHelper.learnSoundSetting = true
        case .noSound:
            UserDefaultsHelper.learnSoundSetting = false
        }
    }
    
    func changed<T>(controlValue: T) {
        guard let isOn = controlValue as? Bool else { return }
        if isOn {
            active = .sound
        } else {
            active = .noSound
        }
        self.saveToUserDefaults(with: value)
    }
    
    func getControlValue<T>() -> T? {
        let value = active == .sound ? true : false
        guard let controlValue = value as? T else { return nil }
        return controlValue
    }
}
