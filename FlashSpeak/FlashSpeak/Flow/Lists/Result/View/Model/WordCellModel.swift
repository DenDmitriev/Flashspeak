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
    let mistake: String
    
    static func modelFactory(word: Word, mistake: String) -> WordCellModel {
        return WordCellModel(
            source: word.source,
            translation: word.translation,
            mistake: mistake
        )
    }
}
