//
//  LearnSettingProtocol.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation
import UIKit.UIImage

protocol LearnSettingsDelegate: AnyObject {
}

protocol LearnSettingProtocol {
    associatedtype Setting: TitleImageable, RawRepresentable
    var active: Setting { get set }
    var value: Int? { get set }
    var all: [Setting] { get }
    var title: String { get }
    var controller: LearnSettingControl { get }
    var delegate: LearnSettingsDelegate? { get set }
    
    static func fromUserDefaults() -> Setting
    func saveToUserDefaults(with value: Int?)
    func changed<T>(controlValue: T)
    func getControlValue<T>() -> T?
}

protocol TitleImageable: CaseIterable {
    var title: String { get }
    var image: UIImage? { get }
}
