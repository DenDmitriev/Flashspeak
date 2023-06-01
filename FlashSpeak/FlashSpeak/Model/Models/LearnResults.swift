//
//  Results.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import Foundation

enum LearnResults: CaseIterable {
    /// Workout duration
    case duration
    /// Number of correct answers
    case rights
    /// Number of training sessions
    case passed
    /// Total training time
    case time
    
    var description: String {
        switch self {
        case .duration:
            return NSLocalizedString("Time", comment: "Description")
        case .rights:
            return NSLocalizedString("Result", comment: "Description")
        case .passed:
            return NSLocalizedString("Total passed", comment: "Description")
        case .time:
            return NSLocalizedString("Total time", comment: "Description")
        }
    }
}
