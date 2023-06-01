//
//  SettingsCellDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 26.05.2023.
//

import UIKit

protocol SettingsCellDelegate: AnyObject {
    func switchChanged(sender: UISwitch, setting: LearnSettings.Question?)
    func segmentedControlChanged(sender: UISegmentedControl, setting: LearnSettings.Settings?)
}
