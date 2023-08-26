//
//  CardError.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import Foundation

enum CardError: LocalizedError {
    
    case imageURL(error: Error)
    case save(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .imageURL(let error):
            return NSLocalizedString("Image URL error", comment: "Error") + error.localizedDescription
        case .save(let error):
            return "\(error)"
        }
    }
}
