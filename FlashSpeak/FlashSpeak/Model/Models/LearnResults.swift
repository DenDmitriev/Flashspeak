//
//  Results.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import Foundation

enum LearnResults: CaseIterable {
    case duration, rights
    
    var description: String {
        switch self {
        case .duration:
            return NSLocalizedString("Time", comment: "Description")
        case .rights:
            return NSLocalizedString("Result", comment: "Description")
        }
    }
}
