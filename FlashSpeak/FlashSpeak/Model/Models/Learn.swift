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
    var count: Int
    
    init(learnCD: LearnCD) {
        self.id = learnCD.id
        self.startTime = learnCD.startTime
        self.finishTime = learnCD.finishTime
        self.result = Int(learnCD.result)
        self.count = Int(learnCD.count)
    }
    
    init(startTime: Date, finishTime: Date, result: Int, count: Int) {
        self.startTime = startTime
        self.finishTime = finishTime
        self.result = result
        self.count = count
    }
    
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
    
    func timeInterval() -> TimeInterval {
        let timeInterval = finishTime.timeIntervalSince(startTime)
        return timeInterval
    }
}
