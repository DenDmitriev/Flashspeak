//
//  SettingsTableView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//
// swiftlint: disable weak_delegate

import UIKit

protocol SettingsViewDelegate: AnyObject {
    
}

class SettingsTableView: UITableView {
    
    // MARK: - Properties
    
    var settingsManager: LearnSettingsManager?
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
        super.init(frame: .zero, style: .insetGrouped)
        settingsTableViewDelegate.view = self
        settingsTableViewDataSource.view = self
        self.dataSource = settingsTableViewDataSource
        self.delegate = settingsTableViewDelegate
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    // MARK: - Functions
    
    // MARK: - Private Functions
    
    private func registerCells() {
        self.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.identifier)
        self.register(SegmentedControlCell.self, forCellReuseIdentifier: SegmentedControlCell.identifier)
        self.register(SwitchValueCell.self, forCellReuseIdentifier: SwitchValueCell.identifier)
    }
}

extension SettingsTableView: SettingsCellDelegate {
    func valueChanged() {
        checkEmptyQuestion()
        checkLanguage()
    }
    
    /// Check for empty qestion
    private func checkEmptyQuestion() {
        if settingsManager?.image == .noImage,
           settingsManager?.word == .noWord,
           settingsManager?.sound == .noSound {
            let numberOfRows = numberOfRows(inSection: LearnSettings.question.rawValue)
            for index in 0...(numberOfRows - 1) {
                let indexPath = IndexPath(row: index, section: LearnSettings.question.rawValue)
                if let cell = cellForRow(at: indexPath) as? SwitchCell {
                    cell.switcher.setOn(true, animated: true)
                    cell.valueChanged(sender: cell.switcher)
                }
            }
        }
    }
    
    /// Check language logic
    private func checkLanguage() {
        if settingsManager?.questionAdapter == .image,
           settingsManager?.language == .target {
            guard let row = settingsManager?.indexForLanguage() else { return }
            let section = LearnSettings.mode.rawValue
            let indexPath = IndexPath(row: row, section: section)
            guard let cell = cellForRow(at: indexPath) as? SegmentedControlCell else { return }
            cell.segmentControl.selectedSegmentIndex = LearnLanguage.Language.source.rawValue
            cell.valueChanged(sender: cell.segmentControl)
        }
    }
}

// swiftlint: enable weak_delegate
