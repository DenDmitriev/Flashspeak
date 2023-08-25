//
//  ChartLearnViewModel.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.06.2023.
//

import Foundation
import Charts

enum LearnStat: String {
    case rights = "Rights answers"
    case duration = "Exercise duration"
}

extension LearnStat: Plottable {
    var primitivePlottable: String {
        return NSLocalizedString(rawValue, comment: "title")
    }
}

struct ChartLearnViewModel {
    let stat: LearnStat
    let date: Date
    let result: Int
    
    static func modelFactory(learnings: [Learn], stats: [LearnStat]) -> [ChartLearnViewModel] {
        var viewModels = [ChartLearnViewModel]()
        stats.forEach { stat in
            let results: [ChartLearnViewModel]
            switch stat {
            case .rights:
                results = learnings
                    .map { ChartLearnViewModel(
                        stat: .rights,
                        date: $0.finishTime,
                        result: $0.result
                    )
                    }
            case .duration:
                results = learnings
                    .map { ChartLearnViewModel(
                        stat: .duration,
                        date: $0.finishTime,
                        result: Int($0.timeInterval())
                    )
                    }
            }
            viewModels.append(contentsOf: results)
        }
        return viewModels
    }
}
