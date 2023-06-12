//
//  LearnSound.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation
import UIKit.UIImage

class LearnSpeaker: LearnSettingProtocol {
    
    typealias Setting = Speaker
    
    enum Speaker: Int, TitleImageable {
        case speaker, noSound
        
        var title: String {
            switch self {
            case .speaker:
                return NSLocalizedString("Speaker", comment: "Title")
            case .noSound:
                return NSLocalizedString("Empty", comment: "Title")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .speaker:
                return UIImage(systemName: "speaker")
            case .noSound:
                return nil
            }
        }
    }
    
    var active: Speaker
    
    var all: [Speaker] {
        Setting.allCases
    }
    
    var title: String
    
    var value: Int?
    
    var controller: LearnSettingControl
    
    weak var delegate: LearnSettingsDelegate?
    
    init(delegate: LearnSettingsDelegate?) {
        self.active = LearnSpeaker.fromUserDefaults()
        self.title = NSLocalizedString("Speaker", comment: "Title")
        self.controller = .switcher
        self.delegate = delegate
    }
    
    static func fromUserDefaults() -> Speaker {
        if UserDefaultsHelper.learnSoundSetting {
            return .speaker
        } else {
            return .noSound
        }
    }
    
    func saveToUserDefaults(with value: Int?) {
        switch active {
        case .speaker:
            UserDefaultsHelper.learnSoundSetting = true
        case .noSound:
            UserDefaultsHelper.learnSoundSetting = false
        }
    }
    
    func changed<T>(controlValue: T) {
        guard let isOn = controlValue as? Bool else { return }
        if isOn {
            active = .speaker
        } else {
            active = .noSound
        }
        self.saveToUserDefaults(with: value)
    }
    
    func getControlValue<T>() -> T? {
        let value = active == .speaker ? true : false
        guard let controlValue = value as? T else { return nil }
        return controlValue
    }
}
