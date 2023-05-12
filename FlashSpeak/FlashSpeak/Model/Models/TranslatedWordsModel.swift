//
//  TranslatedWordsModel.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation

// MARK: - TranslatedWordsModel
struct TranslatedWordsModel: Codable {
    let translatedWord: [TranslatedWord]
}

// MARK: - TranslatedWord
struct TranslatedWord: Codable {
    let sourceWords, translations: SourceWords
}

// MARK: - SourceWords
struct SourceWords: Codable {
    let text: String
}

// MARK: - Alias name
typealias TranslatedWords = TranslatedWordsModel

/*
 {
     "translatedWord": [
         {
             "sourceWords": {
                 "text": "облако"
             },
             "translations": {
                 "text": "cloud"
             }
         },
 */
