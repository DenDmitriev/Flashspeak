//
//  Learn.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import Foundation

struct Learn {
    var id: UUID = UUID()
    var startTime: Date
    var finishTime: Date
    var result: Int
    var learnCount: Int
    
    func duration() -> String {
        let formatter = DateComponentsFormatter()
        switch finishTime.timeIntervalSince(startTime) {
        case ...60:
            formatter.allowedUnits = [.second]
        default:
            formatter.allowedUnits = [.minute, .second]
        }
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = [.default]
        let duration = formatter.string(from: startTime, to: finishTime) ?? "0"
        return duration
    }
}
