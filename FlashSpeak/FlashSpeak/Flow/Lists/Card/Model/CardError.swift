//
//  CardError.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import Foundation

enum CardError: LocalizedError {
    
    case imageURL(error: Error)
    
    var errorDescription: String {
        switch self {
        case .imageURL(let error):
            return "Image service \(error)"
        default:
            return "Unknown error"
        }
    }
}
