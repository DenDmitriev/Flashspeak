//
//  ListError.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.05.2023.
//

import Foundation

enum ListError: LocalizedError {
case delete(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .delete(let error):
            return "\(error.localizedDescription)"
        }
    }
}
