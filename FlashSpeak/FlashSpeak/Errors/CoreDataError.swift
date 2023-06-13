//
//  CoreDataError.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 08.05.2023.
//

import Foundation

enum CoreDataError: LocalizedError {
    case listNotFounded(id: UUID)
    case wordNotFounded(id: UUID)
    case save(description: String)
    
    var errorDescription: String? {
        switch self {
        case .listNotFounded(let id):
            return NSLocalizedString("List not found in CoreData", comment: "Error") + "id: \(id)"
        case .wordNotFounded(let id):
            return NSLocalizedString("Word not found in CoreData", comment: "Error") + "id: \(id)"
        case .save(let description):
            return "\(description)"
        }
    }
}
