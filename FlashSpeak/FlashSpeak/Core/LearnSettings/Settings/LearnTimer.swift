//
//  LearnTimer.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation
import UIKit.UIImage

class LearnTimer: LearnSettingProtocol {
    
    typealias Setting = Timer
    
    enum Timer: Int, TitleImageable {
        case stopwatch
        case timer
        
        var title: String {
            switch self {
            case.timer:
                return NSLocalizedString("Timer", comment: "Title")
            case .stopwatch:
                return NSLocalizedString("Stopwatch", comment: "Title")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .timer:
                return UIImage(systemName: "timer")
            case .stopwatch:
                return UIImage(systemName: "n.circle")
            }
        }
    }
    
    var active: Timer
    
    var isHidden: Bool = false
    
    var all: [Timer] {
        Setting.allCases
    }
    
    var value: Int?
    
    var title: String
    
    var image: UIImage?
    
    var controller: LearnSettingControl
    
    weak var delegate: LearnSettingsDelegate?
    
    init(delegate: LearnSettingsDelegate?) {
        self.active = LearnTimer.fromUserDefaults()
        self.title = NSLocalizedString("Timer", comment: "Title")
        self.image = UIImage(systemName: "timer")
        self.value = UserDefaultsHelper.learnModeTimerSetting
        self.controller = .switcherWithValue
        self.delegate = delegate
    }
    
    static func fromUserDefaults() -> Timer {
        let mode = Timer(rawValue: UserDefaultsHelper.learnModeSetting) ?? .stopwatch
        return mode
    }
    
    func saveToUserDefaults(with value: Int?) {
        UserDefaultsHelper.learnModeSetting = active.rawValue
        switch active {
        case .timer:
            if let timer = value {
                UserDefaultsHelper.learnModeTimerSetting = timer
            }
        default:
            return
        }
    }
    
    func changed<T>(controlValue: T) {
        guard let isOn = controlValue as? Bool else { return }
        if isOn {
            active = .timer
        } else {
            active = .stopwatch
        }
        self.saveToUserDefaults(with: value)
    }
    
    func getControlValue<T>() -> T? {
        let value = active == .timer ? true : false
        guard let controlValue = value as? T else { return nil }
        return controlValue
    }
}


