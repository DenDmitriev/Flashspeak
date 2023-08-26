//
//  CardIndex.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 23.05.2023.
//

import Foundation

struct CardIndex {
    let current: Int
    let count: Int
    
    var label: String {
        return "\(current) / \(count)"
    }
    
    var progress: Float {
        let current = Float(current)
        let total = Float(count)
        return current / total
    }
}
