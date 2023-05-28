//
//  WordCellModel.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.05.2023.
//

import Foundation

struct WordCellModel {
    let source: String
    let translation: String
    
    static func modelFactory(word: Word) -> WordCellModel {
        return WordCellModel(source: word.source, translation: word.translation)
    }
}
