//
//  ListMakerError.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.05.2023.
//

import Foundation

enum ListMakerError: LocalizedError {
    
    case loadTransalte(error: Error)
    case imageURL(error: Error)
    case loadImage
    case unknown
    
    var errorDescription: String {
        switch self {
        case .loadTransalte(let error):
            return "Translate service \(error)"
        case .imageURL(let error):
            return "Image service \(error)"
        case .loadImage:
            return "Image load error"
        default:
            return "Unknown error"
        }
    }
}
