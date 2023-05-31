//
//  SettingsTableView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//
// swiftlint: disable weak_delegate

import UIKit

protocol SettingsViewDelegate: AnyObject {
    func settingsChanged(_ settings: LearnSettings)
}

class SettingsTableView: UITableView {
    
    // MARK: - Properties
    
    var learnSettings: LearnSettings?
    weak var viewDelegate: SettingsViewDelegate?
    
    // MARK: - Private properties
    
    private var settingsTableViewDelegate: SettingsTableViewDelegate
    private var settingsTableViewDataSource: UITableViewDataSource
    
    // MARK: - Constraction
    
    init() {
        let settingsTableViewDelegate = SettingsTableViewDelegate()
        let settingsTableViewDataSource = SettingsTableViewDataSource()
        self.settingsTableViewDelegate = settingsTableViewDelegate
        self.settingsTableViewDataSource = settingsTableViewDataSource
        super.init(frame: .zero, style: .plain)
        settingsTableViewDelegate.view = self
        settingsTableViewDataSource.view = self
        self.dataSource = settingsTableViewDataSource
        self.delegate = settingsTableViewDelegate
        self.separatorStyle = .none
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    // MARK: - Private Functions
    
    private func changeSettings(index: Int, setting: LearnSettings.Settings) {
        switch setting {
        case .question:
            learnSettings?.question = LearnSettings.Question.fromRawValue(index: index)
        case .answer:
            learnSettings?.answer = LearnSettings.Answer.fromRawValue(index: index)
        case .language:
            learnSettings?.language = LearnSettings.Language.fromRawValue(index: index)
        }
        if let learnSettings = learnSettings {
            viewDelegate?.settingsChanged(learnSettings)
        }
    }
    
    private func registerCells() {
        self.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.identifier)
        self.register(SegmentedControlCell.self, forCellReuseIdentifier: SegmentedControlCell.identifier)
    }
}

extension SettingsTableView: SettingsCellDelegate {
    
    // MARK: - Functions
    
    func segmentedControlChanged(sender: UISegmentedControl, setting: LearnSettings.Settings?) {
        guard let setting = setting else { return }
        changeSettings(index: sender.selectedSegmentIndex, setting: setting)
        checkLogicImageAndSourceLanguage()
    }
    
    func switchChanged(sender: UISwitch, setting: LearnSettings.Question?) {
        guard let setting = setting else { return }
        var index: Int = .zero
        switch setting {
        case .word:
            guard let imageCell = self.cellForRow(
                at: IndexPath(
                item: SettingsTableViewDataSource.QuestionSetting.image.rawValue,
                section: SettingsTableViewDataSource.Section.question.numberOfSection
                )
            ) as? SwitchCell else { return }
            let imageSwitcher = imageCell.switcher
            if sender.isOn,
               !imageSwitcher.isOn {
                index = LearnSettings.Question.word.rawValue
            } else if sender.isOn,
               imageSwitcher.isOn {
                index = LearnSettings.Question.wordImage.rawValue
            } else if !sender.isOn,
               imageSwitcher.isOn {
                index = LearnSettings.Question.image.rawValue
            } else if !sender.isOn,
               !imageSwitcher.isOn {
                imageCell.switcher.setOn(true, animated: true)
                imageCell.valueChanged(sender: imageCell.switcher)
            }
        case .image:
            guard let wordCell = self.cellForRow(
                at: IndexPath(
                item: SettingsTableViewDataSource.QuestionSetting.word.rawValue,
                section: SettingsTableViewDataSource.Section.question.numberOfSection
                )
            ) as? SwitchCell else { return }
            let wordSwitcher = wordCell.switcher
            if sender.isOn,
               !wordSwitcher.isOn {
                index = LearnSettings.Question.image.rawValue
            } else if sender.isOn,
               wordSwitcher.isOn {
                index = LearnSettings.Question.wordImage.rawValue
            } else if !sender.isOn,
               wordSwitcher.isOn {
                index = LearnSettings.Question.word.rawValue
            } else if !sender.isOn,
               !wordSwitcher.isOn {
                wordCell.switcher.setOn(true, animated: true)
                wordCell.valueChanged(sender: wordCell.switcher)
            }
        default:
            return
        }
        changeSettings(index: index, setting: .question)
        checkLogicImageAndSourceLanguage()
    }
    
    /// The user cannot answer in their native language the question where only images
    private func checkLogicImageAndSourceLanguage() {
        if learnSettings?.language == .target,
           learnSettings?.question == .image {
            guard let languageCell = self.cellForRow(
                at: IndexPath(
                    item: SettingsTableViewDataSource.QuestionSetting.language.rawValue,
                    section: SettingsTableViewDataSource.Section.question.numberOfSection
                )
            ) as? SegmentedControlCell else { return }
            languageCell.segmentControl.selectedSegmentIndex = LearnSettings.Language.source.rawValue
            languageCell.valueChanged(sender: languageCell.segmentControl)
        }
    }
}

// swiftlint: enable weak_delegate
