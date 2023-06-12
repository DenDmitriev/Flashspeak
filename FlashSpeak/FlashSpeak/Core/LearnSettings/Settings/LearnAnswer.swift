//
//  LearnAnswer.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation
import UIKit.UIImage

class LearnAnswer: LearnSettingProtocol {
    typealias Setting = Answer
    
    enum Answer: Int, TitleImageable {
        case test, keyboard
        
        var title: String {
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
    
    var active: Answer
    
    var all: [Answer] {
        Setting.allCases
    }
    
    var title: String
    
    var image: UIImage?
    
    var value: Int?
    
    var controller: LearnSettingControl
    
    weak var delegate: LearnSettingsDelegate?
    
    init(delegate: LearnSettingsDelegate?) {
        self.active = LearnAnswer.fromUserDefaults()
        self.image = UIImage(systemName: "hand.point.up.left.fill")
        self.title = NSLocalizedString("Answer Mode", comment: "Title")
        self.controller = .selector
        self.delegate = delegate
    }
    
    static func fromUserDefaults() -> Answer {
        return Answer(rawValue: UserDefaultsHelper.learnAnswerSetting) ?? .test
    }
    
    func saveToUserDefaults(with value: Int?) {
        UserDefaultsHelper.learnAnswerSetting = active.rawValue
    }
    
    func changed<T>(controlValue: T) {
        guard let index = controlValue as? Int else { return }
        switch index {
        case Answer.test.rawValue:
            active = .test
        case Answer.keyboard.rawValue:
            active = .keyboard
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
