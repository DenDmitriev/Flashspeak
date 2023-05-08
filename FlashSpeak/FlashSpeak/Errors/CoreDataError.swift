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
    
    var errorDescription: String {
        switch self {
        case .listNotFounded(let id):
            return "List by id:\(id) not found in CoreData"
        case .wordNotFounded(let id):
            return "Word by id:\(id) not found in CoreData"
        case .save(let description):
            return "\(description)"
        }
    }
}
