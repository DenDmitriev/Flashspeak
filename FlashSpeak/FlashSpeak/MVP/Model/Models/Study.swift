//
//  Study.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 16.04.2023.
//

import Foundation

struct Study {
    let id: UUID = UUID()
    var started: Date
    var sourceLanguage: Language
    var targetLanguage: Language
    var lists: [List]
}
