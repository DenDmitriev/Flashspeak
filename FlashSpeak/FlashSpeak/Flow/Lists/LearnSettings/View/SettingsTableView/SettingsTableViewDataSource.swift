//
//  SettingsTableViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//
// swiftlint: disable line_length

import UIKit

class SettingsTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var view: SettingsTableView?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = view?.settingsManager?.count()
        return sections ?? .zero
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = view?.settingsManager?.title(section)
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = view?.settingsManager?.countInSection(section)
        return count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let setting = view?.settingsManager?.settings(indexPath.section)[indexPath.item]
        else { return UITableViewCell() }
        switch setting.controller {
        case .selector:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlCell.identifier, for: indexPath) as? SegmentedControlCell
            else { return UITableViewCell() }
            cell.configure(setting: setting)
            cell.delegate = view
            return cell
        case .switcher:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell
            else { return UITableViewCell() }
            cell.configure(setting: setting)
            cell.delegate = view
            return cell
        case .switcherWithValue:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: SwitchValueCell.identifier, for: indexPath) as? SwitchValueCell
            else { return UITableViewCell() }
            cell.configure(setting: setting)
            cell.delegate = view
            return cell
        }
    }
}

// swiftlint: enable line_length
