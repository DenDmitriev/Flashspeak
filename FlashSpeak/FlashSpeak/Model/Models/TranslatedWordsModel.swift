//
//  TranslatedWordsModel.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation

// MARK: - TranslatesWords
struct TranslatedWordsModel: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let text: String
}

// MARK: - Alias name
typealias TranslatedWords = TranslatedWordsModel
