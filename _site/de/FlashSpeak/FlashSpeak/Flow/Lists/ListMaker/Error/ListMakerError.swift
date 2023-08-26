//
//  ListMakerError.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.05.2023.
//

import Foundation

enum ListMakerError: LocalizedError {
    
    case loadTransalte(description: String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .loadTransalte(let description):
            return description
        default:
            return NSLocalizedString("Unknown error", comment: "Error")
        }
    }
}
