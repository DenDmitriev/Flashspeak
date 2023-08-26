//
//  TransalateResponse.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.06.2023.
//
// Parsing Google API Translation Response

import Foundation

struct TransalateResponse: Decodable {
    var data: Translations
}

struct Translations: Decodable {
    var translations: [TranslatedText]
}

struct TranslatedText: Decodable {
    var translatedText: String
}

/*
 {
     "data": {
         "translations": [
             {
                 "translatedText": "собака"
             },
             {
                 "translatedText": "кот"
             }
         ]
     }
 }
 */
