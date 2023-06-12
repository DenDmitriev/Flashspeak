//
//  LearnImage.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation
import UIKit.UIImage

class LearnImage: LearnSettingProtocol {
    typealias Setting = Image
    
    enum Image: Int, TitleImageable {
        case image, noImage
        
        var title: String {
            switch self {
            case .image:
                return NSLocalizedString("Image", comment: "Title")
            case .noImage:
                return NSLocalizedString("Empty", comment: "Title")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .image:
                return UIImage(systemName: "character")
            case .noImage:
                return nil
            }
        }
    }
    var active: Image
    
    var all: [Image] {
        Setting.allCases
    }
    
    var title: String
    
    var value: Int?
    
    var controller: LearnSettingControl
    
    weak var delegate: LearnSettingsDelegate?
    
    init(delegate: LearnSettingsDelegate?) {
        self.active = LearnImage.fromUserDefaults()
        self.title = NSLocalizedString("Image", comment: "Title")
        self.controller = .switcher
        self.delegate = delegate
    }
    
    static func fromUserDefaults() -> Image {
        if UserDefaultsHelper.learnImageSetting {
            return .image
        } else {
            return .noImage
        }
    }
    
    func saveToUserDefaults(with value: Int?) {
        switch active {
        case .image:
            UserDefaultsHelper.learnImageSetting = true
        case .noImage:
            UserDefaultsHelper.learnImageSetting = false
        }
    }
    
    func changed<T>(controlValue: T) {
        guard let isOn = controlValue as? Bool else { return }
        if isOn {
            active = .image
        } else {
            active = .noImage
        }
        self.saveToUserDefaults(with: value)
    }
    
    func getControlValue<T>() -> T? {
        let value = active == .image ? true : false
        guard let controlValue = value as? T else { return nil }
        return controlValue
    }
}
