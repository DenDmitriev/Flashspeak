//
//  ListMakerError.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.05.2023.
//

import Foundation

enum ListMakerError: LocalizedError {
    
    case loadTransalte(error: Error)
    case unknown
    
    var errorDescription: String {
        switch self {
        case .loadTransalte(let error):
            return NSLocalizedString("Translate service error", comment: "Error") + error.localizedDescription
        default:
            return NSLocalizedString("Unknown error", comment: "Error")
        }
    }
}
