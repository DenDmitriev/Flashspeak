//
//  SettingsTableViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//
// swiftlint: disable line_length

import UIKit

class SettingsTableViewDataSource: NSObject, UITableViewDataSource {
    
    enum QuestionSetting: Int, CaseIterable {
        case language, word, image
    }
    
    enum AnswerSetting: Int, CaseIterable {
        case answer
    }
    
    enum Section: Int, CaseIterable {
        case question, answer
        
        var name: String {
            switch self {
            case .question:
                return NSLocalizedString("Режим вопроса", comment: "Title")
            case .answer:
                return NSLocalizedString("Режим ответа", comment: "Title")
            }
        }
        
        var numberOfRowsInSection: Int {
            switch self {
            case .question:
                return QuestionSetting.allCases.count
            case .answer:
                return AnswerSetting.allCases.count
            }
        }
        
        var numberOfSection: Int {
            return self.rawValue
        }
    }
    
    weak var view: SettingsTableView?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.question.numberOfSection:
            return Section.question.name
        case Section.answer.numberOfSection:
            return Section.answer.name
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.question.numberOfSection:
            return Section.question.numberOfRowsInSection
        case Section.answer.numberOfSection:
            return Section.answer.numberOfRowsInSection
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.question.numberOfSection:
            switch indexPath.row {
            case QuestionSetting.language.rawValue:
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlCell.identifier, for: indexPath) as? SegmentedControlCell,
                    let setting = view?.learnSettings?.language
                else { return UITableViewCell() }
                cell.configure(language: setting)
                cell.delegate = view
                return cell
            case QuestionSetting.word.rawValue:
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell,
                    let setting = view?.learnSettings?.question
                else { return UITableViewCell() }
                cell.configure(setting: setting, for: .word)
                cell.delegate = view
                return cell
            case QuestionSetting.image.rawValue:
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell,
                    let setting = view?.learnSettings?.question
                else { return UITableViewCell() }
                cell.configure(setting: setting, for: .image)
                cell.delegate = view
                return cell
            default:
                return UITableViewCell()
            }
        case Section.answer.numberOfSection:
            switch indexPath.row {
            case AnswerSetting.answer.rawValue:
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlCell.identifier, for: indexPath) as? SegmentedControlCell,
                    let setting = view?.learnSettings?.answer
                else { return UITableViewCell() }
                cell.configure(answer: setting)
                cell.delegate = view
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}

// swiftlint: enable line_length
