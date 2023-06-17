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
        case image, noImage, hidden
        
        var title: String {
            switch self {
            case .image:
                return NSLocalizedString("Image", comment: "Title")
            case .noImage:
                return NSLocalizedString("Empty", comment: "Title")
            case .hidden:
                return "Images are disabled in the list"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .image:
                return UIImage(systemName: "character")
            case .noImage:
                return nil
            case .hidden:
                return nil
            }
        }
    }
    
    var active: Image
    
    var isHidden: Bool = false
    
    var all: [Image] {
        Setting.allCases
    }
    
    var title: String
    
    var image: UIImage?
    
    var value: Int?
    
    var controller: LearnSettingControl
    
    weak var delegate: LearnSettingsDelegate?
    
    init(delegate: LearnSettingsDelegate?, isHidden: Bool) {
        if isHidden {
            self.active = .hidden
            self.isHidden = isHidden
        } else {
            self.active = LearnImage.fromUserDefaults()
        }
        self.image = UIImage(systemName: "photo")
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
        case .hidden:
            return
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
