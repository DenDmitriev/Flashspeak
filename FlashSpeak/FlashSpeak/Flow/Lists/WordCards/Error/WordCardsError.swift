//
//  WordCardsError.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.05.2023.
//

import Foundation

enum WordCardsError: LocalizedError {
    case imageURL(error: Error)
    case loadImage
    case save(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .imageURL(let error):
            return NSLocalizedString("Image URL error", comment: "Error") + error.localizedDescription
        case .loadImage:
            return NSLocalizedString("Image load error", comment: "Error")
        case .save(error: let error):
            return "\(error.localizedDescription)"
        }
    }
}
