//
//  StatisticViewModel.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//

import Foundation

struct StatisticViewModel {
    
    enum Section: Int, CaseIterable {
        case today = 0
        case all = 1
        
        static func section(by rawValue: Int) -> Section? {
            switch rawValue {
            case today.rawValue:
                return .today
            case all.rawValue:
                return .all
            default:
                return nil
            }
        }
        
        var title: String {
            switch self {
            case .all:
                return NSLocalizedString("General", comment: "Title")
            case .today:
                return NSLocalizedString("Today", comment: "Title")
            }
        }
    }
    
    enum Results: CaseIterable {
        case passed, time
        
        var title: String {
            switch self {
            case .passed:
                return NSLocalizedString("Done", comment: "Description")
            case .time:
                return NSLocalizedString("Time", comment: "Description")
            }
        }
        
        var description: String {
            switch self {
            case .passed:
                return NSLocalizedString("classes completed", comment: "Description")
            case .time:
                return NSLocalizedString("in study", comment: "Description")
            }
        }
    }
    
    // MARK: - Properites
    
    var section: Section
    var kind: Results
    
    var result: String
    var title: String
    var description: String
    
    // MARK: - Functions
    
    static func modelFactory(learnings: [Learn]) -> [StatisticViewModel] {
        var viewModels = [StatisticViewModel]()
        Section.allCases.forEach { section in
            switch section {
            case .today:
                let todayLearnings = learnings.filter { Calendar.current.isDateInToday($0.startTime) }
                viewModels.append(contentsOf: results(for: todayLearnings, section: section))
            case .all:
                viewModels.append(contentsOf: results(for: learnings, section: section))
            }
        }
        return viewModels
    }
    
    // MARK: - Private functions
    
    private static func results(for learnings: [Learn], section: Section) -> [StatisticViewModel] {
        var viewModels = [StatisticViewModel]()
        Results.allCases.forEach { result in
            let resultString: String
            switch result {
            case .passed:
                resultString = String(learnings.count)
            case .time:
                resultString = duration(learings: learnings)
            }
            let viewModel = StatisticViewModel(
                section: section,
                kind: result,
                result: resultString,
                title: result.title,
                description: result.description
            )
            viewModels.append(viewModel)
        }
        return viewModels
    }
    
    private static func duration(learings: [Learn]) -> String {
        let duartion = learings.map({ $0.timeInterval() }).reduce(.zero, +)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        let durationString = formatter.string(from: duartion)
        return durationString ?? "N/A"
    }
}
